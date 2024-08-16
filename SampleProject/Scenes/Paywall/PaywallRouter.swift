//
//  PaywallRouter.swift
//  SampleProject
//
//  Created by Bora Erdem on 13.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

final class PaywallRouter: Router, PaywallRouter.Routes {
    typealias Routes = HomeRoute & PresentSafariRoute
}
