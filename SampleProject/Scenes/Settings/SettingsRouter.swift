//
//  SettingsRouter.swift
//  SampleProject
//
//  Created by Bora Erdem on 12.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

final class SettingsRouter: Router, SettingsRouter.Routes {
    typealias Routes = PaywallRoute & PresentSafariRoute & ChangeLanguageRoute
}
