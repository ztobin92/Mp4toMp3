//
//  BatchExportRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 24.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

protocol BatchExportRoute {
    func presentBatchExport(parameters: BatchExportRouteParameters)
}

extension BatchExportRoute where Self: RouterProtocol {
    
    func presentBatchExport(parameters: BatchExportRouteParameters) {
        let router = BatchExportRouter()
        let viewModel = BatchExportViewModel(parameters: parameters,  router: router)
        let viewController = BatchExportViewController(viewModel: viewModel)
        
        let transition = ModalTransition(isAnimated: true, modalTransitionStyle: .coverVertical, modalPresentationStyle: .fullScreen)
        router.viewController = viewController
        router.openTransition = transition
        
        open(viewController, transition: transition)
    }
}

struct BatchExportRouteParameters {
    var urls: [URL]
    var allOutputParameters: [ConvertHelper.OutputParameters]
    var rootNav: UINavigationController
}

