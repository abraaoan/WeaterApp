//
//  SearchView.swift
//  WeaterApp
//
//  Created by Abraao Nascimento on 09/09/2023.
//

import SwiftUI

struct SearchView<SearchViewModelObservable>: View where SearchViewModelObservable: SearchViewModelProtocol {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: SearchViewModelObservable
    @State private var query = ""
    @Binding var selectedCity: City
    
    init(viewModel: SearchViewModelObservable, city: Binding<City>) {
        self.viewModel = viewModel
        _selectedCity = city
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.results, id: \.id) { city in
                    let state = city.state ?? ""
                    VStack(alignment: .leading) {
                        Text("\(city.name)(\(city.country)) \(state)")
                        Text("latitude: \(city.lat), longitude: \(city.lon)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray.opacity(0.75))
                    }
                    .padding(2)
                    .onTapGesture {
                        selectedCity = city
                        dismiss()
                    }
                }
            }
            .searchable(text: $query, prompt: "Search city")
            .onSubmit(of: .search) {
                Task { try? await viewModel.search(query: query) }
            }
            .navigationTitle(viewModel.title)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    @State static var city: City = Mock.city
    static let dataService = MockDataService()
    static let viewModel = SearchViewModel(dataService: dataService)
    
    static var previews: some View {
        SearchView(viewModel: viewModel, city: $city)
    }
}
