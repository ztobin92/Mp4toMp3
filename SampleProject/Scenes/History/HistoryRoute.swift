//
//  HistoryRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 12.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

protocol HistoryRoute {
    func presentHistory()
}

extension HistoryRoute where Self: RouterProtocol {
    
    func presentHistory() {
        let router = HistoryRouter()
        let viewModel = HistoryViewModel(router: router)
        let viewController = HistoryViewController(viewModel: viewModel)
        
        let transition = ModalTransition(animator: nil, isAnimated: true)
        router.viewController = viewController
        router.openTransition = transition
        
        viewController.isModalInPresentation = true
        if let sheet = viewController.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [.custom { _ in ScreenSize.height * 0.45}, .large()]
                sheet.largestUndimmedDetentIdentifier = sheet.detents[0].identifier
            } else {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
            }

            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 40
        }
        
        open(viewController, transition: transition)
    }
}
