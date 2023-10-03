//
//  CardView.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import SwiftUI

struct CardView<CardViewModelObservable>: View where CardViewModelObservable: CardViewModelProtocol {
    @ObservedObject var viewModel: CardViewModelObservable
    
    init(viewModel: CardViewModelObservable) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text(viewModel.time)
            Image(uiImage: viewModel.icon)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 40)
                .cornerRadius(8)
                .redacted(reason: viewModel.isLoading ? .placeholder : [])
            Text(viewModel.temp)
                .padding(.top, 4)
        }
        .padding(4)
        .task {
            Task { viewModel.fetchIcon() }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static let service = MockIconService()
    static let weather = RWeather(time: "22",
                                  icon: "02d",
                                  temp: "25º",
                                  max: "26º",
                                  min: "16º")
    static let viewModel = CardViewModel(weather: weather,
                                         service: service)
    
    static var previews: some View {
        CardView(viewModel: viewModel)
    }
}
