//
//  Settings.swift
//  WheaterApp
//
//  Created by Abraao Nascimento on 28/09/2023.
//

import Foundation

protocol SettingsProtocol {
    var city: Data? { get set }
    var token: String? { get }
}

class UserDefaultsContainer: SettingsProtocol {
    var city: Data? {
        get {
            return UserDefaults.standard.data(forKey: Keys.cityKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.cityKey)
        }
    }
    
    var token: String? {
        UserDefaults.standard.string(forKey: Keys.token)
    }
}

extension UserDefaultsContainer {
    private enum Keys {
        static let cityKey = "kDataCity"
        static let token = "kToken"
    }
}

class UserDefaultsService {
    private var settingsContainer: SettingsProtocol
    
    init(settingsContainer: SettingsProtocol = UserDefaultsContainer()) {
        self.settingsContainer = settingsContainer
    }
    
    var city: Data? {
        get { return settingsContainer.city }
        set { settingsContainer.city = newValue }
    }
    
    var token: String? {
        get { return settingsContainer.token }
    }
}
