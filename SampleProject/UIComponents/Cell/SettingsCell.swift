//
//  SettingsCell.swift
//  SampleProject
//
//  Created by Bora Erdem on 16.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import UIKit
import Defaults

public class SettingsCell: UITableViewCell, ReusableView {
    
    weak var viewModel: SettingsCellProtocol?
    let menuBtn = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    private var lightAction: UIAction {
        UIAction(
            title: AppColorMode.Light.rawValue,
            state: Defaults[.usersColorMode] == AppColorMode.Light.rawValue ? .on : .off,
            handler: { [unowned self] _ in
            changeColorMode(type: .Light)
        })
    }
    
    private var darkAction: UIAction {
        UIAction(
            title: AppColorMode.Dark.rawValue,
            state: Defaults[.usersColorMode] == AppColorMode.Dark.rawValue ? .on : .off,
            handler: { [unowned self] act in
                changeColorMode(type: .Dark)
        })
    }
    
    private var systemAction: UIAction {
        UIAction(
            title: AppColorMode.System.rawValue,
            state: Defaults[.usersColorMode] == AppColorMode.System.rawValue ? .on : .off,
            handler: { [unowned self] _ in
                changeColorMode(type: .System)
        })
    }
    
    private var menu: UIMenu {
        UIMenu(children: [
            systemAction,
            lightAction,
            darkAction,
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContents()
    }
    
    private func configureContents() {
        
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        menuBtn.removeFromSuperview()
    }
    
    public func set(viewModel: SettingsCellProtocol) {
        self.viewModel = viewModel
        
        if viewModel.title == L10n.Modules.Settings.Section.Settings.theme {
            addSubview(menuBtn)
            menuBtn.fillSuperview()
            accessoryView?.isUserInteractionEnabled = false
            menuBtn.showsMenuAsPrimaryAction = true
            menuBtn.menu = menu
        }
        
    }
    
    public func didTapColorTeheme() {
        
    }
    
    public func changeColorMode(type: AppColorMode) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let curWindow = windowScene?.windows.first
        let interfaceStyle = curWindow?.overrideUserInterfaceStyle == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle : window?.overrideUserInterfaceStyle
        
        Defaults[.usersColorMode] = type.rawValue
        switch type {
        case .Dark:
            curWindow?.overrideUserInterfaceStyle = .dark
        case .Light:
            curWindow?.overrideUserInterfaceStyle = .light
        case .System:
            curWindow?.overrideUserInterfaceStyle = .unspecified
        }
        
        menuBtn.menu = menu
    }
    
}

public enum AppColorMode: String, Codable {
    case Dark, Light, System
}
