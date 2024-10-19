//
//  WalkThroughScene2CellModel.swift
//  UIComponents
//
//  Created by Bora Erdem on 14.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation

public protocol WalkThroughScene2CellDataSource: AnyObject {
    
}

public protocol WalkThroughScene2CellEventSource: AnyObject {
    
}

public protocol WalkThroughScene2CellProtocol: WalkThroughScene2CellDataSource, WalkThroughScene2CellEventSource {
    
}

public final class WalkThroughScene2CellModel: WalkThroughCellProtocol {
    public var scene: WalkThroughCellSceneType = .scene2
    
    public var image: UIImage
    
    public var titleText: String
    
    public var descriptionText: String
    
    public init(image: UIImage, titleText: String, descriptionText: String) {
        self.image = image
        self.titleText = titleText
        self.descriptionText = descriptionText
    }
    
}
