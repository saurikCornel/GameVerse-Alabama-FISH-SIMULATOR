//
//  FishermanStorage.swift
//  FishSimulator
//
//  Created by Pavel Ivanov on 26.03.2025.
//

import Foundation

class FishermanStorage {
    static let shared = FishermanStorage()
    
    private let purchasedKey = "purchased_fishermans"
    private let selectedKey = "selected_fisherman"
    var isGreetingShowing: Bool = false
    
    private let defaults = UserDefaults.standard
    
    private let defaultFisherman = "fisherman_default"
    
    private init() {
        // Установить фон по умолчанию, если запускается впервые
        if defaults.string(forKey: selectedKey) == nil {
            defaults.set(defaultFisherman, forKey: selectedKey)
        }
        if defaults.array(forKey: purchasedKey) == nil {
            defaults.set([defaultFisherman], forKey: purchasedKey)
        }
    }
    
    var purchasedFishermans: [String] {
        defaults.stringArray(forKey: purchasedKey) ?? [defaultFisherman]
    }
    
    var selectedFisherman: String {
        defaults.string(forKey: selectedKey) ?? defaultFisherman
    }
    
    func selectFisherman(named name: String) {
        guard purchasedFishermans.contains(name) else { return }
        defaults.set(name, forKey: selectedKey)
    }
    
    func purchaseFisherman(named name: String) {
        var purchased = purchasedFishermans
        guard !purchased.contains(name) else { return }
        purchased.append(name)
        defaults.set(purchased, forKey: purchasedKey)
    }
    
    func isPurchased(name: String) -> Bool {
        purchasedFishermans.contains(name)
    }
}
