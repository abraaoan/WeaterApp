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
    var temp: String { get }
    var time: String { get }
    func fetchIcon()
}

class CardViewModel:  ObservableObject {
    @Published private(set) var icon: UIImage = UIImage(systemName: "cloud")!
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

