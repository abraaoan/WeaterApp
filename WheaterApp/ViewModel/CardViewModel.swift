//
//  CardViewModel.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import Foundation
import UIKit
import Combine

protocol CardViewModelProtocol: ObservableObject {
    var icon: UIImage { get }
    var isLoading: Bool { get }
    var temp: String { get }
    var time: String { get }
    func fetchIcon()
}

class CardViewModel:  ObservableObject {
    @Published private(set) var icon: UIImage = UIImage(systemName: "cloud")!
    @Published private(set) var isLoading: Bool = true
    private(set) var temp: String
    private(set) var time: String
    private let weather: RWeather
    private let service: IconServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(weather: RWeather, service: IconServiceProtocol) {
        self.weather = weather
        self.service = service
        self.temp = weather.temp
        self.time = weather.time
    }
}

// MARK - CardViewModelProtocol

extension CardViewModel: CardViewModelProtocol {
    func fetchIcon() {
        isLoading = true
        service.fetch(iconId: weather.icon)
            .sink {[weak self] status in
                switch status {
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { self.icon = $0 }
            .store(in: &cancellables)
    }
}

