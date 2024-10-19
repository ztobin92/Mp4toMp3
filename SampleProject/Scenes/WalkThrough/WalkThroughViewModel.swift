//
//  WalkThroughViewModel.swift
//  SampleProject
//
//  Created by Murat Celebi on 1.04.2021.
//  Copyright © 2021 Mobillium. All rights reserved.
//

import Foundation
import MobilliumUserDefaults
import Defaults

protocol WalkThroughViewDataSource {
    func numberOfItemsAt(section: Int) -> Int
    func cellItemAt(indexPath: IndexPath) -> WalkThroughCellProtocol
}

protocol WalkThroughViewEventSource {}

protocol WalkThroughViewProtocol: WalkThroughViewDataSource, WalkThroughViewEventSource {
    func didFinishWalkThroughScene()
}

final class WalkThroughViewModel: BaseViewModel<WalkThroughRouter>, WalkThroughViewProtocol {
    
    private var cellItems: [WalkThroughCellProtocol] = [
        WalkThroughScene1CellModel(image: .imgWalkthrough1,
                             titleText: "L10n.Modules.WalkThrough.firstTitle",
                             descriptionText: "L10n.Modules.WalkThrough.descriptionText"),
        WalkThroughScene2CellModel(image: .imgWalkthrough2,
                             titleText: "L10n.Modules.WalkThrough.secondTitle",
                             descriptionText: "L10n.Modules.WalkThrough.descriptionText")
    ]
    
    func numberOfItemsAt(section: Int) -> Int {
        return cellItems.count
    }
    
    func cellItemAt(indexPath: IndexPath) -> WalkThroughCellProtocol {
        return cellItems[indexPath.row]
    }
}

// MARK: - Actions
extension WalkThroughViewModel {
    
    func didFinishWalkThroughScene() {
        Defaults[.firstRun] = false
        router.presentHome()
    }
}
