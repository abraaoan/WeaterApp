//
//  SearchViewModel.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 09/09/2023.
//

import Foundation

protocol SearchViewModelProtocol: ObservableObject {
    var title: String { get }
    var results: [City] { get }
    var selectedCity: City { get }
    
    func search(query: String) async throws
}

class SearchViewModel: ObservableObject {
    @Published var results: [City] = []
    @Published var selectedCity: City = Mock.city
    var title: String { "Change city" }
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    private func handleSearchResult(cities: [City]) async {
        await MainActor.run(body: { [weak self] in
            self?.results = cities
        })
    }
}

extension SearchViewModel: SearchViewModelProtocol {
    
    func search(query: String) async throws {
        let result = await dataService.searchCity(query: query)
        switch result {
        case .success(let cities):
            await handleSearchResult(cities: cities)
        case .failure(let error):
            throw error
        }
    }
}
