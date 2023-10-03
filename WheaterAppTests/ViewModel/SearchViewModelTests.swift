//
//  SearchViewModelTests.swift
//  WheaterAppTests
//
//  Created by Abraao Nascimento on 02/10/2023.
//

import XCTest
@testable import WheaterApp

final class SearchViewModelTests: XCTestCase {
    let service = MockDataService()
    
    func testSearch() async throws {
        // Given
        let query = "Porto"
        
        // When
        let sut = SearchViewModel(dataService: service)
        try await sut.search(query: query)
        
        // Then
        XCTAssertGreaterThanOrEqual(sut.results.count, 1)
    }
    
    func testSearchNoReponse() async {
        // Given
        let query = ""
        
        // When
        let sut = SearchViewModel(dataService: service)
        
        // Then
        do {
            try await sut.search(query: query)
            XCTFail("Show not enter here")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
