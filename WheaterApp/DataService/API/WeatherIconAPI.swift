//
//  WeatherIconAPI.swift
//  WeaterApp
//
//  Created by Abraao Nascimento on 08/09/2023.
//


enum WeatherIconAPI {
    case icon(iconId: String)
}

extension WeatherIconAPI: EndPoint {
    var host: String { "openweathermap.org" }
    var method: RequestMethod { .get }
    var header: [String : String]? { ["Content-Type": "application/json"] }
    var body: [String : String]? { nil }
    var query: String? { nil }
    
    var path: String {
        switch self {
        case let .icon(id):
            return "/img/wn/\(id)@2x.png"
        }
    }
}
