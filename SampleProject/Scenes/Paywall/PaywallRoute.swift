//
//  PaywallRoute.swift
//  SampleProject
//
//  Created by Bora Erdem on 13.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

protocol PaywallRoute {
    func presentPaywall(viewSource: PaywallViewModel.PaywallViewSource)
}

extension PaywallRoute where Self: RouterProtocol {
    
    func presentPaywall(viewSource: PaywallViewModel.PaywallViewSource = .other) {
        let router = PaywallRouter()
        let viewModel = PaywallViewModel(router: router, viewSource: viewSource)
        let viewController = PaywallViewController(viewModel: viewModel)
        
        var transition: Transition!
        
        switch viewSource {
        case .onboard:
            transition = PushTransition()
        case .other:
            transition = ModalTransition(animator: nil, isAnimated: true, modalTransitionStyle: .coverVertical, modalPresentationStyle: .fullScreen)
        }
        
        router.viewController = viewController
        router.openTransition = transition
        
        open(viewController, transition: transition)
    }
}
