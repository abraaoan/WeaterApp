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
                    ForEach(viewModel.sections, id: \.id) { section in
                        Section(header:
                            Text(section.date).padding(
                            EdgeInsets(top: 0,
                                       leading: -16,
                                       bottom: 0,
                                       trailing: 0))
                        ) {
                            ContentCell(section: section,
                                        iconService: iconService,
                                        isLoading: $viewModel.isLoading)
                        }
                        .headerProminence(.increased)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle(viewModel.cityName)
            .toolbar {
                Button("Change city") {
                    viewModel.isShowingSearch.toggle()
                }
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
        HStack {
            NavigationLink("City detail") {
                if let section = viewModel.sections.first {
                    let viewModel = CityViewModelFactory.createCityViewModel(section: section,
                                                                             city: viewModel.currentCity,
                                                                             service: iconService)
                    CityDetailView(viewModel: viewModel)
                        .redacted(reason: self.viewModel.isLoading ? .placeholder : [])
                }
            }
            .padding(.leading, 15.0)
        }
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
                        .padding(4)
                        .redacted(reason: isLoading ? .placeholder : [])
                }
            }
        }
        .padding(6)
        .scrollIndicators(SwiftUI.ScrollIndicatorVisibility.hidden)
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