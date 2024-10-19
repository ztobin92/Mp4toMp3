//
//  AppRouter.swift
//  SampleProject
//
//  Created by Mehmet Salih Aslan on 4.11.2020.
//  Copyright © 2020 Mobillium. All rights reserved.
//

import Foundation
import UIKit
import Defaults
import Foundation
import UIKit
import Defaults
import SuperwallKit

typealias AppRoutes = WalkThroughRoute & HomeRoute & PaywallRoute

final class AppRouter: Router, AppRoutes {
    
    static let shared = AppRouter()

    func startApp() {
        if Defaults[.firstRun] {
            // The user has completed onboarding
            presentHome()

            // Check if the user is not subscribed
            if Defaults[.premium] == false {
                // Trigger the Superwall paywall
                Superwall.shared.register(event: "campaign_trigger")
            }
        } else {
            // The user has not completed onboarding, show the walkthrough
            placeOnWindowWalkThrough()
        }
    }
    
    public func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
