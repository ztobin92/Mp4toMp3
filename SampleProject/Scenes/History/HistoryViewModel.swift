//
//  HistoryViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 12.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import Combine

protocol HistoryViewDataSource {}

protocol HistoryViewEventSource {}

protocol HistoryViewProtocol: HistoryViewDataSource, HistoryViewEventSource {}

final class HistoryViewModel: BaseViewModel<HistoryRouter>, HistoryViewProtocol {
    
    private var cancellable = Set<AnyCancellable>()
    @Published var cacheModels: [CacheModel] = []
    @Published var reversed = false
    var ratingSeen = false
    
    init(router: HistoryRouter) {
        super.init(router: router)
        dismissHistoryView.sink { _ in
            router.close()
        }.store(in: &cancellable)
        if let ids: [String] = CacheHelper.getCachedValue(forKey: CacheHelper.Key.historyIDS.rawValue) {
            cacheModels = ids.compactMap({ id in
                if let model: CacheModel = CacheHelper.getCachedValue(forKey: id) {
                    return model
                } else {
                    return nil
                }
            })
        }
    }
    
    func showRating() {
        if ratingSeen {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            RatingHelper.shared.increaseLikeCountAndShowRatePopup(for: .general)
        }
        ratingSeen = true
    }

    
}

extension HistoryViewModel: ObservableObject {
    
}
