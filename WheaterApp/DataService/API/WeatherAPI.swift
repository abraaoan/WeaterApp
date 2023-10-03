//
//  WeatherAPI.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 08/09/2023.
//

enum WeatherAPI {
    case weather(coord: Coord)
    case city(query: String)
}

extension WeatherAPI: EndPoint {
    var host: String { "api.openweathermap.org" }
    var method: RequestMethod { .get }
    var header: [String : String]? { nil }
    var body: [String : String]? { nil }
    
    var path: String {
        switch self {
        case .city:
            return "/geo/1.0/direct"
        case .weather:
            return "/data/2.5/forecast"
        }
    }
    
    var query: String? {
        switch self {
        case let .city(query):
            return "q=\(query)&limit=\(Constants.limit)\(Constants.appid)"
        case let .weather(coord):
            return "lat=\(coord.lat)&lon=\(coord.lon)\(Constants.appid)&units=metric"
        }
    }
}

extension WeatherAPI {
    private enum Constants {
        static let appid = "&appid=0d07028148d3ee2f418a5568cf8cebc1"
        static let limit = "5"
    }
}
