//
//  MockDataService.swift
//  WeaterApp
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import Foundation
import Combine

class MockDataService: DataServiceProtocol {
    private var cancellables = Set<AnyCancellable>()
    var saveCityToLocalHandler: (() -> ())?
    var fetchWeaterHandler: (() -> ())?
    var userDefaultService: UserDefaultsService
    let loadCity: City
    
    init(userDefaultsContainer: SettingsProtocol = UserDefaultsContainer(), loadCity: City = Mock.city) {
        self.userDefaultService = UserDefaultsService(settingsContainer: userDefaultsContainer)
        self.loadCity = loadCity
    }
    
    func fetchWeater(coord: Coord) async -> Result<Response, Error> {
        if coord.lat == 0 {
            return .failure(RequestError.noResponse)
        }
        
        do {
            let responde = try loadLocalObject(fileName: "forecast", model: Response.self)
            fetchWeaterHandler?()
            return .success(responde)
        } catch {
            return .failure(DiskError.decode)
        }
    }
    
    func searchCity(query: String) async -> Result<[City], Error> {
        if query.isEmpty {
            return .failure(RequestError.invalidURL)
        }
        
        do {
            let responde = try loadLocalObject(fileName: "cities", model: [City].self)
            return .success(responde)
        } catch {
            return .failure(DiskError.decode)
        }
    }
    
    func loadLocalCity() async -> City { loadCity }
    
    func saveCityToLocal(city: City) async {
        guard let saveCityToLocalHandler = saveCityToLocalHandler else {
            assertionFailure("saveCityHandler not instaciated")
            return
        }
        saveCityToLocalHandler()
    }
    
    private func loadLocalObject<T: Decodable>(fileName: String, model: T.Type) throws -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else { throw DiskError.load }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(model.self, from: data)
        } catch {
            throw error
        }
    }
}
