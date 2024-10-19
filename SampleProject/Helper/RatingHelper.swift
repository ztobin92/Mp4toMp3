//
//  RatingHelper.swift
//  SampleProject
//
//  Created by Bora Erdem on 16.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import Defaults
import StoreKit

var askCount = 0

public final class RatingHelper {
    public static let shared = RatingHelper()
    private var lastCustomPromptDate: Date? = nil
    
    public func nativeRating() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }
    
    public func increaseLikeCountAndShowRatePopup(for alert: AlertType) {
        if self.ratingPromptCounterLogic() {
            askCount += 1
            self.prepareCustomRatePopup(for: alert)
        } else {
            SKStoreReviewController.requestReviewInCurrentScene()
        }
    }
    
    private func prepareCustomRatePopup(for alert: AlertType) {
        AlertHelper.showAlert(
            title: alert.title,
            message: alert.subtitle,
            action1Title: alert.action1Title,
            action1Handler: { _ in
            },
            action2Title: alert.action2Title,
            action2Handler: { _ in
                Defaults[.isLovedBefore] = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    SKStoreReviewController.requestReviewInCurrentScene()
                }
            }
        )
    }

    func ratingPromptCounterLogic() -> Bool {
        if Defaults[.isLovedBefore] {
            if !Defaults[.isBonusRatingSeen] {
                Defaults[.isBonusRatingSeen] = true
                return true
            } else {
                return false
            }
        }
        
        if askCount > 1 {
            return false
        } else {
            return true
        }
    }
    
}

public enum AlertType: String {
    case
    welcome = "welcome_alert",
    general = "general_alert",
    onboard = "onboard_alert"
    
    var subtitle: String {
        switch self {
        case .welcome:
            return L10n.Alert.Rating.Welcome.desc
        case .general:
            return L10n.Alert.Rating.General.desc
        case .onboard:
            return "Can you show us some love?"
        }
    }
    
    var title: String {
        switch self {
        case .welcome:
            return L10n.Alert.Rating.Welcome.title
        case .general:
            return L10n.Alert.Rating.General.title
        case .onboard:
            return "Please help us to grow 🙏";
        }
    }
    
    var action1Title: String {
        switch self {
        case .onboard:
            return "Next Time"
        case .general:
            return L10n.Alert.Rating.General.negative
        case .welcome:
            return L10n.Alert.Rating.Welcome.negative
        }
    }
    
    var action2Title: String {
        switch self {
        case .onboard:
            return "Sure!"
        case .general:
            return L10n.Alert.Rating.General.positive
        case .welcome:
            return L10n.Alert.Rating.Welcome.positive
        }
    }
}

import StoreKit

public extension SKStoreReviewController {
    static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}
