//
//  Result.swift
//  WeaterApp
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import Foundation

struct ListResult: Codable {
    let date: Date
    let main: Main
    let weather: [Weather]
    
    private enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main
        case weather
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let date = try container.decode(Double.self, forKey: .date)
        self.main = try container.decode(Main.self, forKey: .main)
        self.weather = try container.decode([Weather].self, forKey: .weather)
        self.date = Date(timeIntervalSince1970: date)
    }
}

extension ListResult {
    init(date: Date, main: Main, weather: [Weather]) {
        self.date = date
        self.main = main
        self.weather = weather
    }
}

struct Main: Codable {
    let temp: Float
    let feelsLike: Float
    let tempMin: Float
    let tempMax: Float
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decode(Float.self, forKey: .temp)
        self.feelsLike = try container.decode(Float.self, forKey: .feelsLike)
        self.tempMin = try container.decode(Float.self, forKey: .tempMin)
        self.tempMax = try container.decode(Float.self, forKey: .tempMax)
    }
}

extension Main {
    init(temp: Float, feelsLike: Float, tempMin: Float, tempMax: Float) {
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
    }
}
