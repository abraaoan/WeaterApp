//
//  SearchViewModelFactory.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 27/09/2023.
//

import Foundation

enum SearchViewModelFactory {
    static func createSearchViewModel(service: DataServiceProtocol) -> SearchViewModel {
        SearchViewModel(dataService: service)
    }
}
