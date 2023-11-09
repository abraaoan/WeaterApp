//
//  ResultWeather.swift
//  WeaterApp
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import Foundation

/// Result weather object.
struct RWeather: Identifiable {
    let id = UUID().uuidString
    let time: String
    let date: String
    let icon: String
    let temp: String
    let max: String
    let min: String
}
