//
//  BackgroundStorage.swift
//  FishSimulator
//
//  Created by Pavel Ivanov on 26.03.2025.
//

import Foundation

class BackgroundStorage {
    static let shared = BackgroundStorage()
    
    private let purchasedKey = "purchased_backgrounds"
    private let selectedKey = "selected_background"
    
    private let defaults = UserDefaults.standard
    
    private let defaultBackground = "river_day"
    
    private init() {
        // Установить фон по умолчанию, если запускается впервые
        if defaults.string(forKey: selectedKey) == nil {
            defaults.set(defaultBackground, forKey: selectedKey)
        }
        if defaults.array(forKey: purchasedKey) == nil {
            defaults.set([defaultBackground], forKey: purchasedKey)
        }
    }
    
    var purchasedBackgrounds: [String] {
        defaults.stringArray(forKey: purchasedKey) ?? [defaultBackground]
    }
    
    var selectedBackground: String {
        defaults.string(forKey: selectedKey) ?? defaultBackground
    }
    
    func selectBackground(named name: String) {
        guard purchasedBackgrounds.contains(name) else { return }
        defaults.set(name, forKey: selectedKey)
    }
    
    func purchaseBackground(named name: String) {
        var purchased = purchasedBackgrounds
        guard !purchased.contains(name) else { return }
        purchased.append(name)
        defaults.set(purchased, forKey: purchasedKey)
    }
    
    func isPurchased(name: String) -> Bool {
        purchasedBackgrounds.contains(name)
    }
}
