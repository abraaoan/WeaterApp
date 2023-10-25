//
//  MainCardViewModel.swift
//  WheaterApp
//
//  Created by Abraao Nascimento on 19/10/2023.
//

import Foundation
import SwiftUI
import Combine

protocol MainCardViewModelProtocol: ObservableObject {
    var temp: String { get }
    var date: String { get }
    var location: String { get }
    var icon: UIImage { get }
    var isLoading: Bool { get }
}

class MainCardViewModel: ObservableObject {
    @Published var temp: String = ".."
    @Published var date: String = "loading..."
    @Published var location: String = "loading..."
    @Published var icon = UIImage(named: "placeholder")!
    @Published var isLoading: Bool = true
    private let service: IconServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    let homeViewModel: any HomeViewModelProtocol
    
    init(homeViewModel: any HomeViewModelProtocol,
         service: IconServiceProtocol = IconService()) {
        self.homeViewModel = homeViewModel
        self.service = service
        startObserving()
    }
    
    private func startObserving() {
        homeViewModel.weatherPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] weather in
                self?.handleResult(weather: weather)
            }
            .store(in: &cancellables)
    }
    
    private func handleResult(weather: RWeather?) {
        guard let weather = weather else { return }
        temp = weather.temp
        date = weather.date
        handleLocation()
        fetchIcon(weather: weather)
        isLoading = false
    }
    
    private func handleLocation() {
        let name = homeViewModel.currentCity.name
        
        if let state = homeViewModel.currentCity.state {
            location = "\(name), \(state)"
        } else {
            location = "\(name)"
        }
    }
    
    private func fetchIcon(weather: RWeather) {
        service.fetch(iconId: weather.icon)
            .sink { status in
                switch status {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] in self?.icon = $0 }
            .store(in: &cancellables)
    }
}

extension MainCardViewModel: MainCardViewModelProtocol {}
