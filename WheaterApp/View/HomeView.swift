//
//  HomeView.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import SwiftUI

struct HomeView<HomeViewModelObservable>: View where HomeViewModelObservable: HomeViewModelProtocol {
    @ObservedObject private var viewModel: HomeViewModelObservable
    let iconService: IconServiceProtocol
    
    init(viewModel: HomeViewModelObservable, iconService: IconServiceProtocol) {
        self.viewModel = viewModel
        self.iconService = iconService
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                header
                List {
                    MainCard
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    ForEach(viewModel.sections, id: \.id) { section in
                        Section(header:
                                    Text(section.date)
                            .font(.system(size: 18, weight: .regular))
                        ) {
                            ContentCell(section: section,
                                        iconService: iconService,
                                        isLoading: $viewModel.isLoading)
                        }
                        .headerProminence(.increased)
                    }
                }
                .listStyle(.inset)
            }
        }
        .sheet(isPresented: $viewModel.isShowingSearch) {
            let viewModel = SearchViewModelFactory.createSearchViewModel(service: viewModel.service)
            SearchView(viewModel: viewModel, city: $viewModel.searchResultCity)
        }
        .task {
            let city = await viewModel.loadCity()
            try? await viewModel.fetchWeater(city: city)
        }
    }
    
    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Weather forecast")
                    .padding(.leading, 15)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("textColor"))
                HStack {
                    NavigationLink(viewModel.cityName) {
                        if let section = viewModel.sections.first {
                            let viewModel = CityViewModelFactory.createCityViewModel(section: section,
                                                                                     city: viewModel.currentCity,
                                                                                     service: iconService)
                            CityDetailView(viewModel: viewModel)
                                .redacted(reason: self.viewModel.isLoading ? .placeholder : [])
                        }
                    }
                    .foregroundColor(Color("textColor").opacity(0.5))
                    .buttonStyle(.plain)
                    .padding(.leading, 15.0)
                }
            }
            Spacer()
            Circle()
                .fill(LinearGradient(colors: [Color("cardDark").opacity(0.5),
                                              Color("cardLight").opacity(0.5)],
                                     startPoint: .bottom,
                                     endPoint: .top))
                .frame(width: 60)
                .padding(.trailing, 20)
        }
    }
    
    private var MainCard: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text("Today")
                    .padding(.leading, 25)
                    .padding(.top, 25)
                Spacer()
                Text("23º")
                    .padding(.leading, 25)
                    .font(.system(size: 38, weight: .bold))
                Spacer()
                Text("Porto, Portugal")
                    .padding(.leading, 25)
                    .padding(.bottom, 25)
            }
            Spacer()
            VStack {
                Text("Thur, 4 de out")
                    .padding(.trailing, 25)
                    .padding(.top, 25)
                Spacer()
                Image("placeholder") .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .padding(.trailing, 25)
                    .padding(.top, -125)
            }
        }
        .font(.system(size: 14))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity,
               minHeight: (UIScreen.main.bounds.size.width - 40) / 2,
               maxHeight: (UIScreen.main.bounds.size.width - 40) / 2)
        .background(LinearGradient(colors: [Color("mainCardDark"), Color("mainCardLight")],
                                   startPoint: .bottom,
                                   endPoint: .top))
        .cornerRadius(20)
        .padding(.leading, 15)
        .padding(.trailing, 15)
        .shadow(color: .black.opacity(0.15), radius: 2, y: 2)
    }
}

private struct ContentCell: View {
    let section: RSection
    let iconService: IconServiceProtocol
    @Binding var isLoading: Bool
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(section.weather, id: \.id) { weather in
                    let viewModel = CardViewModelFactory.createCardViewModel(rweather: weather,
                                                                             service: iconService)
                    CardView(viewModel: viewModel)
                        .redacted(reason: isLoading ? .placeholder : [])
                        .padding(.leading, 6)
                }
            }
            .padding(.top, 3.0)
            .padding(.bottom, 3.0)
            .padding(.trailing, 26)
            .offset(x: 14)
        }
        .scrollIndicators(SwiftUI.ScrollIndicatorVisibility.hidden)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static let service = MockDataService()
    static let iconService = MockIconService()
    static let viewModel = HomeViewModel(service: service)
    
    static var previews: some View {
        HomeView(viewModel: viewModel,
                 iconService: iconService)
    }
}
