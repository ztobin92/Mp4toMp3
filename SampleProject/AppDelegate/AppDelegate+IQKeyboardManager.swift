//
//  AppDelegate+IQKeyboardManager.swift
//  SampleProject
//
//  Created by Murat Celebi on 2.06.2021.
//  Copyright © 2021 Mobillium. All rights reserved.
//

import IQKeyboardManagerSwift

extension AppDelegate {
    
    func configureIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(EditViewController.self)
    }
}
