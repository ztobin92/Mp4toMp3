//
//  CacheHelper.swift
//  SampleProject
//
//  Created by Bora Erdem on 21.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation

public final class CacheHelper {
    
    public static let defaults = UserDefaults.standard
    
    public static func cache<T: Codable>(value: T, forKey key: String) {
        guard let data = try?  JSONEncoder().encode(value) else {return}
        defaults.set(data, forKey: key)
    }
    
    public static func getCachedValue<T: Codable>(forKey key: String) -> T? {
        guard
            let data = defaults.value(forKey: key) as? NSData,
            let item = try? JSONDecoder().decode(T.self, from: data as Data)
        else {return nil}
        return item
    }
    
    public static func clearCache(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    @frozen enum Key: String {
        case historyIDS
    }
}

struct CacheModel: Identifiable, Codable {
    var id = UUID()
    var url: String
    var imageData: Data
    
    var name: String
    var startSecond: CGFloat
    var finishSecond: CGFloat
    var format: String
    var bitrate: Int
    var sampleRate: Int
    var volume: CGFloat
    var channels: Int
    var speed: CGFloat

}

