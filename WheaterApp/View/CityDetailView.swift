//
//  CityDetailView.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import SwiftUI
import MapKit

struct CityDetailView<CityViewModelObservable>: View where CityViewModelObservable: CityViewModelProtocol {
    @ObservedObject private var viewModel: CityViewModelObservable
    
    init(viewModel: CityViewModelObservable) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.date)
                    .fontWeight(.bold)
            }
            .padding(.leading, 15.0)
            .padding(.bottom, -10.0)
            
            HStack(spacing: 25) {
                Image(uiImage: viewModel.icon)
                    .scaledToFit()
                    .frame(width: 60, height: 50)
                Text(viewModel.temp)
                    .font(.largeTitle)
            }
            .padding(.leading, 15.0)
            HStack {
                Text("max: \(viewModel.max), min: \(viewModel.min)")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(.top, -20)
            .padding(.leading, 15.0)
            .padding(.bottom, 15.0)
            
            Map(coordinateRegion: $viewModel.coordinateRegion,
                annotationItems: viewModel.anotationItems) {item in
                MapMarker(coordinate: item.coordinate)
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
        }
        .navigationTitle(viewModel.title)
        .onAppear {
            viewModel.fetchIcon()
        }
    }
}

struct CityDetailView_Previews: PreviewProvider {
    static let service = MockIconService()
    static let section = Mock.section
    static let city = Mock.city
    static let viewModel = CityViewModel(section: section,
                                         city: city,
                                         iconService: service)
    
    static var previews: some View {
        CityDetailView(viewModel: viewModel)
    }
}
