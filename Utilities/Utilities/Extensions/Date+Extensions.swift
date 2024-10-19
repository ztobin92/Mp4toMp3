//
//  Date+Extensions.swift
//  Utilities
//
//  Created by Bora Erdem on 21.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation

public extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

