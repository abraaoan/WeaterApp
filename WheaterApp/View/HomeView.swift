//
//  HomeView.swift
//  WeaterApp
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import SwiftUI

struct HomeView<HomeViewModelObservable>: View where HomeViewModelObservable: HomeViewModelProtocol {
    @ObservedObject private var viewModel: HomeViewModelObservable
    let iconService: IconServiceProtocol
    let mainCardViewModel: MainCardViewModel
    
    init(viewModel: HomeViewModelObservable, iconService: IconServiceProtocol, mainCardViewModel: MainCardViewModel) {
        self.viewModel = viewModel
        self.iconService = iconService
        self.mainCardViewModel = mainCardViewModel
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                header
                List {
                    MainCardView(viewModel: mainCardViewModel)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
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
                .animation(.easeIn, value: !viewModel.isLoading)
                .listStyle(.inset)
            }
        }
        .sheet(isPresented: $viewModel.isShowingSearch) {
            let viewModel = SearchViewModelFactory.createSearchViewModel(service: viewModel.service)
            SearchView(viewModel: viewModel, city: $viewModel.searchResultCity)
        }
        .task {
            let city = await viewModel.loadCity()
            await viewModel.fetchWeater(city: city)
        }
    }
    
    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Weather forecast")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("textColor"))
                HStack {
                    Text(viewModel.cityName)
                    .foregroundColor(Color("textColor").opacity(0.5))
                    .buttonStyle(.plain)
                    .onTapGesture { viewModel.isShowingSearch.toggle() }
                    
                    Image(uiImage: UIImage(systemName: "chevron.down")!)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 8)
                        .foregroundColor(Color("textColor").opacity(0.5))
                }
                .padding(.top, -12)
            }
            .padding(.leading, 20)
            Spacer()
            Circle()
                .fill(LinearGradient(colors: [viewModel.isLoading ? .gray.opacity(0.5) : Color("cardDark").opacity(0.5),
                                              viewModel.isLoading ? .gray.opacity(0.25) : Color("cardLight").opacity(0.5)],
                                     startPoint: .bottom,
                                     endPoint: .top))
                .frame(width: 60)
                .padding(.trailing, 20)
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
    static let userDefault = MockUserDefaultContainer()
    static let service = MockDataService(userDefaultsContainer: userDefault)
    static let loadingStateService = MockDataService(userDefaultsContainer: userDefault, loadCity: Mock.emptyCity)
    static let iconService = MockIconService()
    static let viewModel = HomeViewModel(service: service)
    static let loadingViewModel = HomeViewModel(service: loadingStateService)
    static let mainCardViewModel = MainCardViewModel(homeViewModel: viewModel)
    
    static var previews: some View {
        Group {
            HomeView(viewModel: viewModel,
                     iconService: iconService,
                     mainCardViewModel: mainCardViewModel)
            .previewDisplayName("Full Home")
            
            HomeView(viewModel: loadingViewModel,
                     iconService: iconService,
                     mainCardViewModel: mainCardViewModel)
            .previewDisplayName("Placeholder")
        }
    }
}
