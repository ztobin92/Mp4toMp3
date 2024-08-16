//
//  ExportViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 17.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import AVFAudio
import AVFoundation
import Defaults

protocol ExportViewDataSource {}

protocol ExportViewEventSource {}

protocol ExportViewProtocol: ExportViewDataSource, ExportViewEventSource {}

final class ExportViewModel: BaseViewModel<ExportRouter>, ExportViewProtocol {
    
    @Published var audioPlayerManager = AudioPlayerManager()
    var ratingSeen = false
    
    var parameters: ExportRouteParameters
    private var isCachedBefore = false
    
    init(parameters: ExportRouteParameters, router: ExportRouter) {
        self.parameters = parameters
        super.init(router: router)
        audioPlayerManager.url = parameters.assetURL
        audioPlayerManager.setupPlayer()
    }
    
    var fileSize: String {
        getFileSizeString(from: parameters.assetURL) ?? "NaN"
    }
    
    func getFileSizeString(from url: URL) -> String? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let fileSize = fileAttributes[.size] as? NSNumber {
                return formatFileSize(fileSize.uint64Value)
            } else {
                return nil
            }
        } catch {
            print("Dosya boyutu alınırken hata oluştu: \(error)")
            return nil
        }
    }

    func formatFileSize(_ size: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useKB, .useGB] // Kullanılacak birimler
        formatter.countStyle = .file
        formatter.includesUnit = true // Birimin sonuçta gösterilmesi
        formatter.isAdaptive = true // Dosya boyutuna göre en uygun birimin kullanılması
        return formatter.string(fromByteCount: Int64(size))
    }
    
    func download() {
        showRating()
        ConvertHelper.shared.downloadAudioFromURL(audioURL: parameters.assetURL, parameters: parameters.outputParameters) { result in
            switch result {
            case .success(_):
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    ToastPresenter.showWarningToast(text: L10n.Alert.downloaded, position: .bottomNote, color: .appBlue)
                    cache()
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    ToastPresenter.showWarningToast(text: failure.localizedDescription, position: .toast, color: .red)
                }
            }
        }
    }
    
    func share() {
        showRating()
        let url = parameters.assetURL
        ConvertHelper.shared.downloadAudioFromURL(audioURL: url, parameters: parameters.outputParameters, destination: .temp) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let shareUrl):
                    router.presentShareSheet(items: [shareUrl])
                    cache()
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func cache() {
        
        if parameters.comesFromCache || isCachedBefore {return}
        
        ConvertHelper.shared.downloadAudioFromURL(audioURL: parameters.assetURL, parameters: parameters.outputParameters, destination: .cache) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let url):
                executeCache(downloadedFile: url)
                isCachedBefore = true
            case .failure(let failure):
                ToastPresenter.showWarningToast(text: failure.localizedDescription, color: .red)
            }
        }
        
        func executeCache(downloadedFile: URL) {
            let cacheModel = CacheModel(
                url: downloadedFile.absoluteString,
                imageData: parameters.outputParameters.image.jpegData(compressionQuality: 0.8) ?? Data(),
                name: parameters.outputParameters.name,
                startSecond: parameters.outputParameters.startSecond,
                finishSecond: parameters.outputParameters.finishSecond,
                format: parameters.outputParameters.format.rawValue,
                bitrate: parameters.outputParameters.bitrate.rawValue,
                sampleRate: parameters.outputParameters.sampleRate.rawValue,
                volume: parameters.outputParameters.volume,
                channels: parameters.outputParameters.channels,
                speed: parameters.outputParameters.speed)
            
            CacheHelper.cache(value: cacheModel, forKey: cacheModel.id.uuidString)
            
            if var ids: [String] = CacheHelper.getCachedValue(forKey: CacheHelper.Key.historyIDS.rawValue) {
                ids.insert(cacheModel.id.uuidString, at: 0)
                CacheHelper.cache(value: ids, forKey: CacheHelper.Key.historyIDS.rawValue)
            } else {
                CacheHelper.cache(value: [cacheModel.id.uuidString], forKey: CacheHelper.Key.historyIDS.rawValue)
            }
        }
    }
    
    func showRating() {
        if ratingSeen {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            RatingHelper.shared.increaseLikeCountAndShowRatePopup(for: .general)
        }
        ratingSeen = true
    }
    
}

extension ExportViewModel: ObservableObject {
}

