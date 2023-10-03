//
//  EndPointTests.swift
//  WheaterAppTests
//
//  Created by Abraao Nascimento on 28/09/2023.
//

import XCTest
@testable import WheaterApp

final class WeatherAPITests: XCTestCase {

    func testWeatherRequest() {
        // Given (Arrange)
        let coord = Mock.coord
        
        // When (Act)
        let sut = WeatherAPI.weather(coord: coord)
        
        // Then (Assert)
        XCTAssertEqual(sut.path, "/data/2.5/forecast")
        XCTAssertEqual(sut.query, "lat=\(coord.lat)&lon=\(coord.lon)\(Constants.appid)&units=metric")
        XCTAssertEqual(sut.method, .get)
        XCTAssertNil(sut.body)
        XCTAssertNil(sut.header)
    }
    
    func testRequestUrl() {
        // Given (Arrange)
        let coord = Mock.coord
        let sut = WeatherAPI.weather(coord: coord)
        
        // When (Act)
        var urlComponents = URLComponents()
        urlComponents.scheme = sut.scheme
        urlComponents.host = sut.host
        urlComponents.path = sut.path
        urlComponents.query = sut.query
        
        guard let url = urlComponents.url?.absoluteString else {
            XCTFail("Invalid url")
            return
        }
        
        // Then (Assert)
        XCTAssertEqual(url, "http://api.openweathermap.org/data/2.5/forecast?lat=\(coord.lat)&lon=\(coord.lon)\(Constants.appid)&units=metric")
        
    }
    
    func testCityRequest() {
        // Given (Arrange)
        let query = "Porto"
        
        // When (Act)
        let sut = WeatherAPI.city(query: query)
        
        // Then (Assert)
        XCTAssertEqual(sut.path, "/geo/1.0/direct")
        XCTAssertEqual(sut.query, "q=\(query)&limit=\(Constants.limit)\(Constants.appid)")
        XCTAssertEqual(sut.method, .get)
        XCTAssertNil(sut.body)
        XCTAssertNil(sut.header)
    }
    
    func testCityUrl() {
        // Given (Arrange)
        let query = "Porto"
        let sut = WeatherAPI.city(query: query)
        
        // When (Act)
        var urlComponents = URLComponents()
        urlComponents.scheme = sut.scheme
        urlComponents.host = sut.host
        urlComponents.path = sut.path
        urlComponents.query = sut.query
        
        guard let url = urlComponents.url?.absoluteString else {
            XCTFail("Invalid url")
            return
        }
        
        // Then (Assert)
        XCTAssertEqual(url, "http://api.openweathermap.org/geo/1.0/direct?q=\(query)&limit=\(Constants.limit)\(Constants.appid)")
    }
}

extension WeatherAPITests {
    private enum Constants {
        static let appid = "&appid=0d07028148d3ee2f418a5568cf8cebc1"
        static let limit = "5"
    }
}
