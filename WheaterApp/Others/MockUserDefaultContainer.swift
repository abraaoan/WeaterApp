//
//  MockUserDefaultContainer.swift
//  WheaterApp
//
//  Created by Abraao Nascimento on 02/10/2023.
//

import Foundation

class MockUserDefaultContainer: SettingsProtocol {
    var city: Data? {
        get {return "{\"name\":\"Porto\",\"lat\":41.1494512,\"lon\":-8.6107884,\"country\":\"PT\" }".data(using: .utf8)}
        set {}
    }
    
    var token: String? { "mockApiToken" }
}
