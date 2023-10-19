//
//  HomeViewModel.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import Foundation

protocol HomeViewModelProtocol: ObservableObject {
    var cityName: String { get }
    var sections: [RSection] { get }
    var isShowingSearch: Bool { get set }
    var isLoading: Bool { get set }
    var searchResultCity: City { get set }
    var currentCity: City { get }
    var service: DataServiceProtocol { get }
    
    func fetchWeater(city: City) async
    func loadCity() async -> City
    func didChangeCity(city: City) async
}

class HomeViewModel: ObservableObject {
    @Published var cityName = "Loading ..."
    @Published var sections = [RSection]()
    @Published var isShowingSearch = false
    @Published var isLoading: Bool = true
    @Published var searchResultCity: City = Mock.city {
        didSet {
            Task { await didChangeCity(city: searchResultCity) }
        }
    }
    var currentCity: City = Mock.city
    var service: DataServiceProtocol
    
    init(service: DataServiceProtocol) {
        self.service = service
    }
    
    private func handleServiceResult(city: City, response: Response) async {
        await MainActor.run(body: { [weak self] in
            self?.isLoading = false
            self?.cityName = city.name
            self?.sections = WeatherFactory.createWeathers(response: response)
        })
    }
    
    private func saveCity(city: City) async throws {
        try await service.saveCityToLocal(city: city)
    }
    
    private func addPlaceholderCards() async {
        await MainActor.run(body: { [weak self] in
            self?.isLoading = true
            self?.sections = WeatherFactory.createWeathers(response: Mock.response)
        })
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func fetchWeater(city: City) async {
        await addPlaceholderCards()
        let serviceResponse = await service.fetchWeater(coord: Coord(lat: city.lat, lon: city.lon))

        switch serviceResponse {
        case let .success(response):
            await handleServiceResult(city: city, response: response)
            
        case let .failure(error):
            //throw error
            print(error.localizedDescription)
        }
    }
    
    func loadCity() async -> City {
        let city = await service.loadLocalCity()
        currentCity = city
        return city
    }
    
    func didChangeCity(city: City) async {
        await fetchWeater(city: city)
        await MainActor.run(body: { [weak self] in
            self?.currentCity = city
            self?.cityName = city.name
        })
        try? await saveCity(city: city)
    }
}
