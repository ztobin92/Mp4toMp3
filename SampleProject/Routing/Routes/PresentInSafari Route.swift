//
//  PresentInSafari Route.swift
//  SampleProject
//
//  Created by Bora Erdem on 16.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import SafariServices

protocol PresentSafariRoute {
    func presentInSafari(with url: URL)
}

extension PresentSafariRoute where Self: RouterProtocol {

    func presentInSafari(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        AppRouter.shared.topViewController()?.present(safariVC, animated: true)
    }
}
