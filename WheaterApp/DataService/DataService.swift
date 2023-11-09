//
//  DataService.swift
//  WeaterApp
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import Foundation
import Combine

protocol DataServiceProtocol {
    func fetchWeater(coord: Coord) async -> Result<Response, Error>
    func searchCity(query: String) async -> Result<[City], Error>
    func loadLocalCity() async -> City
    func saveCityToLocal(city: City) async throws
}

actor DataService: HTTPCLient, DataServiceProtocol {
    private var cancellables = Set<AnyCancellable>()
    var userDefaultService: UserDefaultsService
    
    init(userDefaultsContainer: UserDefaultsContainer = UserDefaultsContainer()) {
        self.userDefaultService = UserDefaultsService(settingsContainer: userDefaultsContainer)
    }
    
    func fetchWeater(coord: Coord) async -> Result<Response, Error> {
        await withCheckedContinuation({ continuation in
            request(endPoint: WeatherAPI.weather(coord: coord), model: Response.self)
                .sink { status in
                    switch status {
                    case .finished: break
                    case let .failure(error):
                        continuation.resume(returning: .failure(error))
                    }
                } receiveValue: { response in
                    continuation.resume(returning: .success(response))
                }.store(in: &cancellables)
        })
    }
    
    func searchCity(query: String) async -> Result<[City], Error> {
        await withCheckedContinuation({ continuation in
            request(endPoint: WeatherAPI.city(query: query), model: [City].self)
                .sink { status in
                    switch status {
                    case .finished: break
                    case let .failure(error):
                        continuation.resume(returning: .failure(error))
                    }
                } receiveValue: { response in
                    continuation.resume(returning: .success(response))
                }
                .store(in: &cancellables)
            
        })
    }
    
    func saveCityToLocal(city: City) async throws {
        if !isCityValid(city: city) { throw RequestError.unknown }
        
        do {
            let data = try JSONEncoder().encode(city)
            userDefaultService.city = data
        } catch {
           throw error
        }
    }
    
    func loadLocalCity() async -> City {
        guard let data = userDefaultService.city else { return Constant.defaultCity }
        do {
            let city = try JSONDecoder().decode(City.self, from: data)
            return city
        } catch {
            print("Error when try get city.\n\(error.localizedDescription)")
            return Constant.defaultCity
        }
    }
    
    private func isCityValid(city: City) -> Bool {
        
        if city.name.isEmpty || city.country.isEmpty {
            return false
        }
        
        if city.lat == 0 || city.lon == 0 {
            return false
        }
        
        return true
    }
}

extension DataService {
    private enum Constant {
        static let cityDataKey = "kDataCity"
        static let defaultCity = Mock.city
    }
}
