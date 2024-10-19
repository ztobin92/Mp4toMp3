//
//  Defaults+Keys.swift
//  SampleProject
//
//  Created by Bora Erdem on 16.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import Defaults
import Localize_Swift

public extension Defaults.Keys {
    static let usersColorMode = Key<String>("usersColorMode", default: AppColorMode.System.rawValue)
    static let premium = Key<Bool>("premium", default: false)
    static let firstRun = Key<Bool>("firstRun", default: true)
    static let isLovedBefore = Key<Bool>("isLovedBefore", default: false)
    static let isBonusRatingSeen = Key<Bool>("isBonusRatingSeen", default: false)
    static let prefferedLanguage = Key<String?>("prefferedLanguage")
    static let remainingCount = Key<Int>("remainingCount", default: 3)
}



