//
//  LocalizableManager.swift
//  UIComponents
//
//  Created by Bora Erdem on 26.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import Combine

public final class LocalizableManager {
    
    static public var globalLocalize = PassthroughSubject<String, Never>()
    static var cancellable = Set<AnyCancellable>()
    static var lang: String = "en"
    static public func observe() {
        
        if let path = Bundle.main.path(forResource: "en", ofType: "lproj") {
            bundle = Bundle(path: path)
        }
        
        LocalizableManager.globalLocalize.sink { lan in
            lang = lan
            if let path = Bundle.main.path(forResource: lan, ofType: "lproj") {
                bundle = Bundle(path: path)
            }
        }.store(in: &cancellable)
    }
    
    static public func setup(with lan: String) {
        lang = lan
    }
    
    static var bundle: Bundle?
}
