//
//  EditViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 13.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftUI

protocol EditViewDataSource {}

protocol EditViewEventSource {}

protocol EditViewProtocol: EditViewDataSource, EditViewEventSource {}

final class EditViewModel: BaseViewModel<EditRouter>, EditViewProtocol {
    
    var isRatingTriggeredBefore = false
    var urls: [URL] = []
    @Published var trimManager: [TrimManager] = []
    
    lazy var assets: [AVAsset] = {
        urls.map { url in
            AVAsset(url: url)
        }
    }()
    
    lazy var fileNames: [String] = {
        urls.compactMap{$0.deletingPathExtension().lastPathComponent}
    }()
    
    init(urls: [URL], router: EditRouter) {
        self.urls = urls
        super.init(router: router)
        outputName = fileNames.first ?? "File"
        trimManager = urls.map({ _ in
            TrimManager()
        })
    }
    
    // Output Parameters
    @Published var outputName = "File" {
        willSet {
            fileNames[0] = newValue
        }
    }
    @Published var outputFormat: ConvertHelper.OutputFormat = .MP3 {
        didSet {
            triggerRating()
        }
    }
    @Published var outputBitRate: ConvertHelper.BitRate = .v144 {
        didSet {
            // BitRate değiştiğinde, uygun SampleRate ve Channel değerlerini güncelle
            updateAvailableSampleRates()
            updateOutputChannel()
            triggerRating()
        }
    }
    @Published var outputSampleRate: ConvertHelper.SampleRate = .v44100 {
        didSet {
            triggerRating()
        }
    }
    @Published var outputStartSecond: Double = 0
    @Published var outputFinishSecond: Double = 0
    @Published var outputChannel: CGFloat = 2 {
        didSet {
            triggerRating()
        }
    }
    @Published var outputSpeed: Double = 1.0 {
        didSet {
            triggerRating()
        }
    }
    @Published var outputVolume: Double = 1.0 {
        didSet {
            triggerRating()
        }
    }
    
    @Published var availableSampleRates: [ConvertHelper.SampleRate] = [.v48000, .v44100]

     init(router: EditRouter) {
         super.init(router: router)
         updateAvailableSampleRates()
    }
    
    func updateAvailableSampleRates() {
        // Seçilen BitRate'e göre uygun SampleRate'leri belirleyen mantık
        let currentBitRate = outputBitRate.rawValue
        
        // BitRate'e göre uygun SampleRate'leri filtreleyin
        availableSampleRates = ConvertHelper.SampleRate.allCases.filter { sampleRate in
            switch currentBitRate {
            case 0...11999:
                return sampleRate == .v22050 || sampleRate == .v24000
            case 12000...17999:
                return sampleRate == .v32000
            case 18000...39999:
                return sampleRate == .v32000 || sampleRate == .v44100 || sampleRate == .v48000
            case 40000...56000:
                return sampleRate == .v32000 || sampleRate == .v44100 || sampleRate == .v48000
            case 56001...111999:
                return sampleRate == .v32000 || sampleRate == .v44100 || sampleRate == .v48000
            case 112000...:
                return  sampleRate == .v44100 || sampleRate == .v48000
            default:
                return false
            }
            
        }
        
        // Eğer mevcut seçili SampleRate artık uygun değilse, ilk uygun değeri seç
        if !availableSampleRates.contains(outputSampleRate) {
            outputSampleRate = availableSampleRates.first ?? .v44100
        }
    }
    
    func updateOutputChannel() {
        // Seçilen BitRate'e göre uygun Channel değerini belirleyen mantık
        let currentBitRate = outputBitRate.rawValue
        
        // BitRate'e göre uygun Channel'ı ayarlayın
        if currentBitRate <= 56000 || currentBitRate > 160000 {
            outputChannel = 1 // Önerilen: Tek kanal (Mono) için BitRate 56000 veya daha düşük
        } else {
            outputChannel = 2 // Önerilen: Çift kanal (Stereo) için BitRate 56001 veya daha yüksek
        }
    }
    
    func didTapExport(completion: @escaping ([URL?], [ConvertHelper.OutputParameters]) -> Void) {
        let dispatch = DispatchGroup()
        
        var audioURLs: [URL?] = []
        var allOutputParameters: [ConvertHelper.OutputParameters] = []
        
        urls.enumerated().forEach { i, url in
            dispatch.enter()
            print("Processing URL: \(url)") // Add log here
            
            guard let trimmer = trimManager[i].trimmerView else {
                print("No trimmer view available") // Log missing trimmer view
                completion([], [])
                dispatch.leave()
                return
            }
            
            let name = fileNames[i]
            outputStartSecond = trimmer.startTime?.seconds ?? 0
            outputFinishSecond = trimmer.endTime?.seconds ?? 0

            let outputParameters = ConvertHelper.OutputParameters(
                name: name,
                startSecond: trimmer.startTime?.seconds ?? 0,
                finishSecond: trimmer.endTime?.seconds ?? 0,
                format: outputFormat,
                bitrate: outputBitRate,
                sampleRate: outputSampleRate,
                volume: outputVolume,
                channels: Int(outputChannel),
                speed: outputSpeed,
                image: trimManager[i].coverImage
            )
            
            ConvertHelper.shared.convertVideo(for: urls[i], parameters: outputParameters) { url in
                if let url {
                    audioURLs.append(url)
                    allOutputParameters.append(outputParameters)
                    print("Successfully processed URL: \(url)") // Log success
                } else {
                    print("Failed to process URL: \(url)") // Log failure
                }
                dispatch.leave()
            }
        }
        
        dispatch.notify(queue: .main) {
            print("All URLs processed") // Add log here
            completion(audioURLs, allOutputParameters)
        }
    }

    
    func triggerRating() {
        if isRatingTriggeredBefore {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            RatingHelper.shared.increaseLikeCountAndShowRatePopup(for: .general)
        }
        isRatingTriggeredBefore = true
    }
    
}

extension EditViewModel: ObservableObject {
    
}
