//
//  HomeViewFactory.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 27/09/2023.
//

import Foundation

enum HomeViewFactory {
    static func createHomeViewModel(service: DataServiceProtocol) -> HomeViewModel {
        HomeViewModel(service: service)
    }
}
