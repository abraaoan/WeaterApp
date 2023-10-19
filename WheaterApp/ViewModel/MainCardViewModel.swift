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
}

class MainCardViewModel: ObservableObject {
    @Published var temp: String = ""
    @Published var date: String = ""
    @Published var location: String = ""
    @Published var icon = UIImage(named: "placeholder")!
    private var cancellables = Set<AnyCancellable>()
    
    let homeViewModel: any HomeViewModelProtocol
    
    init(homeViewModel: any HomeViewModelProtocol) {
        self.homeViewModel = homeViewModel
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
        print("---> tep: \(weather.temp) date: \(weather.date) location: \(homeViewModel.currentCity.name) \(homeViewModel.currentCity.state ?? "")")
        temp = weather.temp
        date = weather.date
        handleLocation()
    }
    
    private func handleLocation() {
        let name = homeViewModel.currentCity.name
        
        if let state = homeViewModel.currentCity.state {
            location = "\(name), \(state)"
        } else {
            location = "\(name)"
        }
    }
}

extension MainCardViewModel: MainCardViewModelProtocol {}
