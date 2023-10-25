//
//  HomeViewModelTests.swift
//  WheaterAppTests
//
//  Created by Abraao Nascimento on 02/10/2023.
//

import XCTest
@testable import WheaterApp

final class HomeViewModelTests: XCTestCase {
    let service = MockDataService()
    
    func testFetchWeaterResponse() async {
        // Given
        let city = Mock.city
        
        // When
        let sut = HomeViewModel(service: service)
        await sut.fetchWeater(city: city)
        
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.cityName, city.name)
        XCTAssertGreaterThanOrEqual(sut.sections.count, 1)
    }
    
    func testFetchWeaterNoResponse() async {
        // Given
        let city = City(name: "No Response",
                        lat: 0,
                        lon: 0,
                        country: "",
                        state: nil)
        
        // When
        let sut = HomeViewModel(service: service)
        await sut.fetchWeater(city: city)
        
        // Then
        XCTAssertEqual(sut.sections.count, 0)
    }
    
    func testLoadCity() async {
        // Given
        let userDefaultContainer = MockUserDefaultContainer()
        let service = MockDataService(userDefaultsContainer: userDefaultContainer)
        
        // When
        let sut = HomeViewModel(service: service)
        let city  = await sut.loadCity()
        
        // Then
        XCTAssertEqual(city.name, "Porto")
        
    }
    
    
    func testdidChangeCity() async throws {
        // Given
        let city = Mock.city
        let expectation = expectation(description: "Should save current city to local")
        
        // When
        service.saveCityToLocalHandler = { expectation.fulfill() }
        let sut = HomeViewModel(service: service)
        await sut.didChangeCity(city: city)
        
        // Then
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.cityName, city.name)
        XCTAssertGreaterThanOrEqual(sut.sections.count, 1)
        
        await fulfillment(of: [expectation], timeout: 0.5)
    }
    
    func testDidSetSearchResultCity() async {
        // Given
        let city = Mock.city
        let saveExpectation = expectation(description: "Should save current city to local")
        let fetchExpectation = expectation(description: "Should fetch weather for the current city")
        
        // When
        service.saveCityToLocalHandler = { saveExpectation.fulfill() }
        service.fetchWeaterHandler = { fetchExpectation.fulfill() }
        let sut = HomeViewModel(service: service)
        sut.searchResultCity = city
        
        // Then
        await fulfillment(of: [saveExpectation,
                               fetchExpectation],
                          timeout: 0.5)
    }
}
