//
//  BatchExportViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 24.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation

protocol BatchExportViewDataSource {}

protocol BatchExportViewEventSource {}

protocol BatchExportViewProtocol: BatchExportViewDataSource, BatchExportViewEventSource {}

final class BatchExportViewModel: BaseViewModel<BatchExportRouter>, BatchExportViewProtocol {
    let parameters: BatchExportRouteParameters
    var allPlayerManagers: [AudioPlayerManager] = []
    
    var isCachedBefore = false
    var ratingSeen = false
    
    init(parameters: BatchExportRouteParameters, router: BatchExportRouter) {
        self.parameters = parameters
        super.init(router: router)
    }
    
    func downloadAll() {
        showRating()
        
        let dispatch = DispatchGroup()
        let urls = parameters.urls
        
        parameters.allOutputParameters.forEach({_ in dispatch.enter()})
        parameters.allOutputParameters.enumerated().forEach { i, outputParameters in
            ConvertHelper.shared.downloadAudioFromURL(audioURL: urls[i], parameters: outputParameters, destination: .documents) { _ in
                dispatch.leave()
            }
        }
        
        dispatch.notify(queue: .global(qos: .default)) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                cacheAll()
                DispatchQueue.main.async {
                    ToastPresenter.showWarningToast(text: L10n.Alert.Batch.downloaded,position: .bottomNote, color: .appBlue)
                }
                
            }
        }
    }
    
    func shareAll() {
        showRating()
        
        let dispatch = DispatchGroup()
        
        var urlsToShare: [URL] = []
        let assetUrls: [URL] = parameters.urls
        
        parameters.allOutputParameters.forEach({_ in dispatch.enter()})
        parameters.allOutputParameters.enumerated().forEach { i, parameters in
            ConvertHelper.shared.downloadAudioFromURL(audioURL: assetUrls[i], parameters: parameters, destination: .temp) { result in
                switch result {
                case .success(let urlToShare):
                    urlsToShare.append(urlToShare)
                    dispatch.leave()
                case .failure(_):
                    dispatch.leave()
                }
            }
        }
        
        dispatch.notify(queue: .global(qos: .default)) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                router.presentShareSheet(items: urlsToShare)
                cacheAll()
            }
        }
    }
    
    func cacheAll() {
        
        if isCachedBefore { return }
        
        let dispatch = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 0)
        
        var assetUrls: [URL] = parameters.urls
        parameters.allOutputParameters.forEach({_ in dispatch.enter()})
        parameters.allOutputParameters.enumerated().forEach { i, parameters in
            ConvertHelper.shared.downloadAudioFromURL(audioURL: assetUrls[i], parameters: parameters, destination: .cache) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let url):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        executeCache(parameters: parameters, downloadedFile: url) {
                            dispatch.leave()
                            semaphore.wait()
                        }
                    }
                    semaphore.signal()
                case .failure(let failure):
                    ToastPresenter.showWarningToast(text: failure.localizedDescription, color: .red)
                    dispatch.leave()
                }
            }
        }
        
        dispatch.notify(queue: .main) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                isCachedBefore = true
            }
        }
        
        func executeCache(parameters: ConvertHelper.OutputParameters, downloadedFile: URL, completion: VoidClosure) {
            let cacheModel = CacheModel(
                url: downloadedFile.absoluteString,
                imageData: parameters.image.jpegData(compressionQuality: 0.8) ?? Data(),
                name: parameters.name,
                startSecond: parameters.startSecond,
                finishSecond: parameters.finishSecond,
                format: parameters.format.rawValue,
                bitrate: parameters.bitrate.rawValue,
                sampleRate: parameters.sampleRate.rawValue,
                volume: parameters.volume,
                channels: parameters.channels,
                speed: parameters.speed)
            
            CacheHelper.cache(value: cacheModel, forKey: cacheModel.id.uuidString)
            if var ids: [String] = CacheHelper.getCachedValue(forKey: CacheHelper.Key.historyIDS.rawValue) {
                ids.insert(cacheModel.id.uuidString, at: 0)
                CacheHelper.cache(value: ids, forKey: CacheHelper.Key.historyIDS.rawValue)
                completion()
            } else {
                CacheHelper.cache(value: [cacheModel.id.uuidString], forKey: CacheHelper.Key.historyIDS.rawValue)
                completion()
            }
            
        }
    }
    
    
    func didTapClose() {
        cacheAll()
        parameters.rootNav.popToRootViewController(animated: true)
        router.close()
    }
    
    func showRating() {
        if ratingSeen {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            RatingHelper.shared.increaseLikeCountAndShowRatePopup(for: .general)
        }
        ratingSeen = true
    }
}

extension BatchExportViewModel: ObservableObject {
    
}
