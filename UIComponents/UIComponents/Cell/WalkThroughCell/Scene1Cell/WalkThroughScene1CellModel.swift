//
//  WalkThroughScene1CellModel.swift
//  UIComponents
//
//  Created by Bora Erdem on 14.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation

public protocol WalkThroughScene1CellDataSource: AnyObject {
    
}

public protocol WalkThroughScene1CellEventSource: AnyObject {
    
}

public protocol WalkThroughScene1CellProtocol: WalkThroughScene1CellDataSource, WalkThroughScene1CellEventSource {
    
}

public final class WalkThroughScene1CellModel: WalkThroughCellProtocol {
    public var scene: WalkThroughCellSceneType = .scene1
    
    public var image: UIImage
    
    public var titleText: String
    
    public var descriptionText: String
    
    public init(image: UIImage, titleText: String, descriptionText: String) {
        self.image = image
        self.titleText = titleText
        self.descriptionText = descriptionText
    }
    
}
