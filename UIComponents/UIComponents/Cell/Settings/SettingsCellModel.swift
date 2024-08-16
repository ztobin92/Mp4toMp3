//
//  SettingsCellModel.swift
//  UIComponents
//
//  Created by Bora Erdem on 12.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation

public protocol SettingsCellDataSource: AnyObject {
    var image: UIImage {get}
    var title: String {get}
    var action: VoidClosure {get}
}

public protocol SettingsCellEventSource: AnyObject {
    
}

public protocol SettingsCellProtocol: SettingsCellDataSource, SettingsCellEventSource {
    
}

public final class SettingsCellModel: SettingsCellProtocol {
    public var image: UIImage
    public var title: String
    public var action: VoidClosure
    
    
    public init(image: UIImage, title: String, action: @escaping VoidClosure) {
        self.image = image
        self.title = title
        self.action = action
    }
}
