//
//  ExportRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 17.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import SwiftUI

protocol ExportRoute {
    func presentExport(parameters: ExportRouteParameters)
}

extension ExportRoute where Self: RouterProtocol {
    func presentExport(parameters: ExportRouteParameters) {
        let router = ExportRouter()
        let viewModel = ExportViewModel(parameters: parameters, router: router)
        let viewController = ExportViewController(viewModel: viewModel)
        
        // Set modalPresentationStyle before presenting the view controller
        viewController.modalPresentationStyle = .fullScreen
        viewController.rootNavController = parameters.rootNav
        
        let transition = ModalTransition(isAnimated: true, modalTransitionStyle: .coverVertical, modalPresentationStyle: .fullScreen)
        router.viewController = viewController
        router.openTransition = transition
        
        // Check if the current view controller is already presenting another view controller
        if let presentingVC = router.viewController?.presentedViewController {
            print("A view controller is already being presented: \(presentingVC)")
            return
        }

        open(viewController, transition: transition)
    }
}


struct ExportRouteParameters {
    var rootNav: UINavigationController
    var assetURL: URL
    var outputParameters: ConvertHelper.OutputParameters
    var comesFromCache: Bool = false
}
