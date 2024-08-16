//
//  EditRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 13.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

protocol EditRoute {
    func pushEdit(urls: [URL])
}

extension EditRoute where Self: RouterProtocol {
    
    func pushEdit(urls: [URL]) {
        let router = EditRouter()
        let viewModel = EditViewModel(urls: urls, router: router)
        let viewController = EditViewController(viewModel: viewModel)
        
        let transition = PushTransition()
        router.viewController = viewController
        router.openTransition = transition
        
        open(viewController, transition: transition)
    }
}
