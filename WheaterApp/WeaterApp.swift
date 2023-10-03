//
//  CocusTuiChallengeApp.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import SwiftUI
import Combine

@main
struct WeaterApp: App {
    let service = DataService()
    let iconService = IconService()
    let viewModel: HomeViewModel
    
    init() {
        self.viewModel = HomeViewFactory.createHomeViewModel(service: service)
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: viewModel,
                     iconService: iconService)
        }
    }
}
