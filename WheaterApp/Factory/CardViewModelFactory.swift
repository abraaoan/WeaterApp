//
//  CardViewModelFactory.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 27/09/2023.
//

import Foundation

enum CardViewModelFactory {
    static func createCardViewModel(rweather: RWeather, service: IconServiceProtocol) -> CardViewModel {
        CardViewModel(weather: rweather, service: service)
    }
}
