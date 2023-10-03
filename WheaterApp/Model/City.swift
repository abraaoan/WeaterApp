//
//  City.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 09/09/2023.
//

import Foundation

struct City: Codable, Identifiable {
    var id = UUID()
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, lat, lon, country, state
    }
}
