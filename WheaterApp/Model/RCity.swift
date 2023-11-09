//
//  City.swift
//  WeaterApp
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import Foundation

struct RCity: Codable {
    let id: Int
    let coord: Coord
    let country: String
    let name: String
}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}
