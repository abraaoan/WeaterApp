//
//  CardViewModelTests.swift
//  WheaterAppTests
//
//  Created by Abraao Nascimento on 28/09/2023.
//

import XCTest
import Combine
@testable import WheaterApp

final class CardViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    let weather = Mock.weather
    let iconService = MockIconService()
    
    func testConstructorVars() {
        // Given (Arrange)
        let weather = RWeather(time: "17:35",
                               date: "25 Out",
                               icon: "02D",
                               temp: "24º",
                               max: "25º",
                               min: "18º")
        // When (Act)
        let sut = CardViewModel(weather: weather, service: iconService)
        
        // Then (Assert)
        XCTAssertEqual(sut.temp, weather.temp)
        XCTAssertEqual(sut.time, weather.time)
    }
    
    func testFetchIcon() {
        // Given
        let expectation = expectation(description: "fecth method finish")
        
        // When
        iconService.fetchDidFinishHandle = { expectation.fulfill() }
        let sut = CardViewModel(weather: weather, service: iconService)
        sut.fetchIcon()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
