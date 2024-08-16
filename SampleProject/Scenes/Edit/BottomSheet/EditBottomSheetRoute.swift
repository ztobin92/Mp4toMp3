//
//  EditBottomSheetRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 13.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import SwiftUI

protocol EditBottomSheetRoute {
    func presentEditBottomSheet(editVM: EditViewModel)
}

extension EditBottomSheetRoute where Self: RouterProtocol {
    
    func presentEditBottomSheet(editVM: EditViewModel) {
        let router = EditBottomSheetRouter()
        let viewModel = EditBottomSheetViewModel(editVM: editVM, router: router)
        let viewController = EditBottomSheetViewController(viewModel: viewModel)
        
        let transition = ModalTransition()
        router.viewController = viewController
        router.openTransition = transition
        
        viewController.isModalInPresentation = true
        if let sheet = viewController.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [.custom { _ in ScreenSize.height * 0.3}, .large(), .custom { _ in 70}, ]
                sheet.largestUndimmedDetentIdentifier = sheet.detents[0].identifier
                sheet.selectedDetentIdentifier = sheet.detents[0].identifier
            } else {
                sheet.detents = [.large()]
                sheet.largestUndimmedDetentIdentifier = .large
            }

            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 40
        }
        
        open(viewController, transition: transition)
    }
}
