//
//  SettingsRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 12.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

protocol SettingsRoute {
    func pushSettings()
}

extension SettingsRoute where Self: RouterProtocol {
    
    func pushSettings() {
        let router = SettingsRouter()
        let viewModel = SettingsViewModel(router: router)
        let viewController = SettingsViewController(viewModel: viewModel)
        
        let transition = PushTransition()
        router.viewController = viewController
        router.openTransition = transition
        
        open(viewController, transition: transition)
    }
}
