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
        VStack(alignment: .leading) {
            Text(viewModel.time)
                .font(.system(size: 12))
                .foregroundColor(Color("textColor"))
                .padding(.bottom, 0)
            Image(uiImage: viewModel.icon)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 40)
                .cornerRadius(30)
                .padding(.leading, 25)
                .padding(.top, -14)
            Text(viewModel.temp)
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(Color("textColor"))
                .padding(.top, -4)
        }
        .padding(10)
        .background(
            BgCardShape()
                .fill(LinearGradient(colors: [Color("cardDark"),
                                              Color("cardLight")],
                                     startPoint: .bottomLeading,
                                     endPoint: .topTrailing))
                .shadow(color: .black.opacity(0.15), radius: 2, y: 2))
        .task {
            Task { viewModel.fetchIcon() }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static let service = MockIconService()
    static let weather = RWeather(time: "22",
                                  date: "Thur, 04 Out",
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
