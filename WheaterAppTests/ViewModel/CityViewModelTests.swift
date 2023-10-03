//
//  CityViewModelTests.swift
//  WheaterAppTests
//
//  Created by Abraao Nascimento on 28/09/2023.
//

import XCTest
import Combine
@testable import WheaterApp

final class CityViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    let iconService = MockIconService()
    
    func testConstrutor() {
        // Given
        let section = RSection(date: "Sunday, Sep 10",
                               weather: [
                                 RWeather(time: "19",
                                          icon: "02d",
                                          temp: "36º",
                                          max: "36º",
                                          min: "17º")
                               ])
        let city = City(name: "Porto",
                        lat: 41.1494512,
                        lon: -8.6107884,
                        country: "PT",
                        state: nil)
        
        // When
        let sut = CityViewModel(section: section,
                                city: city,
                                iconService: iconService)
        
        // Then
        XCTAssertEqual(sut.title, city.name)
        XCTAssertEqual(sut.temp, section.weather.first?.temp ?? "-")
        XCTAssertEqual(sut.max, section.weather.first?.max ?? "-")
        XCTAssertEqual(sut.min, section.weather.first?.min ?? "-")
        XCTAssertEqual(sut.date, section.date + ", \(section.weather.first?.time ?? "")h")
        XCTAssertEqual(sut.coordinateRegion.center.latitude, city.lat)
        XCTAssertEqual(sut.coordinateRegion.center.longitude, city.lon)
        
    }
    
    func testFectchIcon() {
        // Given
        let section = Mock.section
        let city = Mock.city
        let expectation = expectation(description: "fecth method finish")
        
        // When
        iconService.fetchDidFinishHandle = { expectation.fulfill() }
        let sut = CityViewModel(section: section,
                                city: city,
                                iconService: iconService)
        sut.fetchIcon()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }

}
