//
//  CityViewModelFactory.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 27/09/2023.
//

import Foundation

enum CityViewModelFactory {
    static func createCityViewModel(section: RSection,
                                    city: City,
                                    service: IconServiceProtocol) -> CityViewModel {
        CityViewModel(section: section,
                      city: city,
                      iconService: service)
    }
}
