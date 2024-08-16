//
//  ToastPresenter.swift
//  UIComponents
//
//  Created by Mehmet Salih Aslan on 24.03.2021.
//  Copyright © 2021 Mobillium. All rights reserved.
//

import SwiftEntryKit

public class ToastPresenter {
    
    public static func showWarningToast(text: String, position: EKAttributes = .topFloat, color: UIColor = .appBlue, handler: VoidClosure? = nil) {
        var attributes = position
        attributes.entryBackground = .color(color: EKColor(light: color, dark: color))
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        let customView = TostWarningView(text: text)
        
        customView.onTap {
            handler?()
        }
        
        SwiftEntryKit.display(entry: customView, using: attributes)
    }
}
