//
//  ChangeLanguageRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 25.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

protocol ChangeLanguageRoute {
    func pushChangeLanguage()
}

extension ChangeLanguageRoute where Self: RouterProtocol {
    
    func pushChangeLanguage() {
        let router = ChangeLanguageRouter()
        let viewModel = ChangeLanguageViewModel(router: router)
        let viewController = ChangeLanguageViewController(viewModel: viewModel)
        
        let transition = PushTransition()
        router.viewController = viewController
        router.openTransition = transition
        
        open(viewController, transition: transition)
    }
}
