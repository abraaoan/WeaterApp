//
//  DataServiceTests.swift
//  WheaterAppTests
//
//  Created by Abraao Nascimento on 28/09/2023.
//

import XCTest
@testable import WheaterApp

final class DataServiceTests: XCTestCase {

    let sut = DataService()
    
    func testFetchWeaterResponse() async {
        // Given (Arrange)
        let coordinator = Mock.coord
        
        // When (Act)
        let result = await sut.fetchWeater(coord: coordinator)
        
        // Then (Assert)
        switch result {
        case .success(let respose):
            assert(respose.cod == "200")
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFetchWeaterNoResponse() async {
        // Given (Arrange)
        let coordinator = Coord(lat: 0, lon: 0)
        
        // When (Act)
        let result = await sut.fetchWeater(coord: coordinator)
        
        // Then (Assert)
        switch result {
        case .success:
            XCTFail("this test should not has a response")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it is missing.")
        }
    }
    
    func testSearchCityResponse() async {
        // Given (Arrange)
        let query = "Porto"
        
        // When (Act)
        let result = await sut.searchCity(query: query)
        
        // Then (Assert)
        switch result {
        case .success(let response):
            guard let first = response.first else {
                XCTFail("Could not get first result")
                return
            }
            XCTAssertEqual(first.name, query)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSearchCityNoResponse() async {
        // Given (Arrange)
        let query = ""
        
        // When (Act)
        let result = await sut.searchCity(query: query)
        
        // Then (Assert)
        switch result {
        case .success:
            XCTFail("this test should not has a response")
        case .failure(let error):
            guard let error = error as? RequestError else {
                XCTFail("Could not convert error to Request error")
                return
            }
            XCTAssertEqual(error, RequestError.unexpectedStatusCode)
        }
    }
    
    func testloadLocalCity() async {
        // Given (Arrange)
        let city = Mock.city
        do {
            try await sut.saveCityToLocal(city: city)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        // When (Act)
        let result = await sut.loadLocalCity()
        
        // Then (Assert)
        XCTAssertEqual(result.name, city.name)
    }
    
    func testSaveMockCity() async {
        // Given (Arrange)
        let city = Mock.city
        let expectation = expectation(description: "should enter in do block")

        // When (Act)

        do {
            try await sut.saveCityToLocal(city: city)
            expectation.fulfill()
        } catch {
            XCTFail(error.localizedDescription)
        }

        // Then (Assert)
        await fulfillment(of: [expectation])
    }
    
    func testSaveFakeCity() async {
        // Given (Arrange)
        let city = City(name: "", lat: 0, lon: 0, country: "", state: nil)

        // When (Act)

        do {
            try await sut.saveCityToLocal(city: city)
            XCTFail("Shouldn't enter here")
        } catch {
            guard let error = error as? RequestError else {
                XCTFail("Could not convert error to Request error")
                return
            }
            XCTAssertEqual(error, RequestError.unknown)
        }

        // Then (Assert)
        
    }
}
