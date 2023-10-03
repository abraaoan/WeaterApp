//
//  ResultSection.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import Foundation

/// Result section object.
struct RSection: Identifiable {
    let id: String = UUID().uuidString
    let date: String
    let weather: [RWeather]
}
