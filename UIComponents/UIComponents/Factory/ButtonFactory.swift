//
//  ButtonFactory.swift
//  UIComponents
//
//  Created by Mehmet Salih Aslan on 22.03.2021.
//  Copyright © 2021 Mobillium. All rights reserved.
//

import Foundation
import SwiftUI

public class ButtonFactory {
    
    public enum Style {
        case large
        case medium
        case small
        
        var height: CGFloat {
            switch self {
            case .large: return 60
            case .medium: return 50
            case .small: return 40
            }
        }
        
        var fontSize: UIFont.FontSize {
            switch self {
            case .large: return .xLarge
            case .medium: return .medium
            case .small: return .medium
            }
        }
    }
    
    public static func createPrimaryButton(style: Style) -> UIButton {
        let button = HighlightedButton()
        
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.appWhite, for: .normal)
        button.backgroundColor = .appBlue
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: style.height).isActive = true
        
        let blur = Rectangle()
            .foregroundColor(.clear)
            .frame(width: 288, height: 54)
            .background(Color(red: 0.13, green: 0.64, blue: 0.94).opacity(0.5))
            .cornerRadius(20)
            .blur(radius: 25)
            .asUIKit()
        
        button.addSubview(blur)
        blur.centerXToSuperview()
        blur.centerYToSuperview(offset: 20)
        button.sendSubviewToBack(blur)

        
        return button
    }
    
    public static func createPrimaryBorderedButton(style: Style) -> UIButton {
        let button = UIButtonBuilder()
            .titleFont(.font(.nunitoBold, size: style.fontSize))
            .titleColor(.appRed)
            .backgroundColor(.appWhite)
            .cornerRadius(4)
            .borderWidth(2)
            .borderColor(UIColor.appRed.cgColor)
            .build()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: style.height).isActive = true
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        return button
    }
    
}
