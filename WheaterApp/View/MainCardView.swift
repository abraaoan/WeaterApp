//
//  MainCardView.swift
//  WheaterApp
//
//  Created by Abraao Nascimento on 19/10/2023.
//

import SwiftUI

struct MainCardView<MainCardViewModelObservable>: View where MainCardViewModelObservable: MainCardViewModelProtocol {
    
    @ObservedObject var viewModel: MainCardViewModelObservable
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text("Today")
                    .padding(.leading, 25)
                    .padding(.top, 25)
                Spacer()
                Text(viewModel.temp)
                    .padding(.leading, 25)
                    .font(.system(size: 38, weight: .bold))
                Spacer()
                Text(viewModel.location)
                    .padding(.leading, 25)
                    .padding(.bottom, 25)
            }
            Spacer()
            VStack {
                Text(viewModel.date)
                    .padding(.trailing, 25)
                    .padding(.top, 25)
                Spacer()
                Image("placeholder") .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)
                    .padding(.trailing, 25)
                    .padding(.top, -125)
            }
        }
        .font(.system(size: 14))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity,
               minHeight: (UIScreen.main.bounds.size.width - 30) / 2,
               maxHeight: (UIScreen.main.bounds.size.width - 30) / 2)
        .background(LinearGradient(colors: [Color("mainCardDark"), Color("mainCardLight")],
                                   startPoint: .bottom,
                                   endPoint: .top))
        .cornerRadius(20)
        .padding(.top, 15)
        .padding(.leading, 15)
        .padding(.trailing, 15)
        .shadow(color: .black.opacity(0.15), radius: 2, y: 2)
        .redacted(reason: viewModel.isLoading ? .placeholder : [])
    }
}

struct MainCardView_Previews: PreviewProvider {
    static let service = MockDataService()
    static let homeViewModel = HomeViewModel(service: service)
    static let viewModel = MainCardViewModel(homeViewModel: homeViewModel)
    
    static var previews: some View {
        Group {
            MainCardView(viewModel: viewModel)
                .previewDisplayName("Default")
            
            MainCardView(viewModel: viewModel)
                .previewDisplayName("Placeholder")
        }
    }
}
