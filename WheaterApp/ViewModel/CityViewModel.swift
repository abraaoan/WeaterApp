//
//  CityViewModel.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 10/09/2023.
//

import Foundation
import Combine
import MapKit

protocol CityViewModelProtocol: ObservableObject {
    var coordinateRegion: MKCoordinateRegion { get set }
    var anotationItems: [PinAnnotation] { get }
    var icon: UIImage { get }
    var title: String { get }
    var temp: String { get }
    var max: String { get }
    var min: String { get }
    var date: String { get }
    
    func fetchIcon()
}

class CityViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    var coordinateRegion = MKCoordinateRegion()
    var anotationItems = [PinAnnotation]()
    @Published var icon: UIImage = UIImage(named: "placeholder")!
    
    private let iconService: IconServiceProtocol
    private let section: RSection
    private let city: City
    let title: String
    let temp: String
    let max: String
    let min: String
    let date: String
    
    init(section: RSection,
         city: City,
         iconService: IconServiceProtocol) {
        self.section = section
        self.iconService = iconService
        self.title = city.name
        self.city = city
        self.temp = section.weather.first?.temp ?? "-"
        self.max = section.weather.first?.max ?? "-"
        self.min = section.weather.first?.min ?? "-"
        self.date = section.date + ", \(section.weather.first?.time ?? "")h"
        
        setup()
    }
    
    func setup() {
        coordinateRegion.center.latitude = city.lat
        coordinateRegion.center.longitude = city.lon
        coordinateRegion.span.latitudeDelta = Constant.delta
        coordinateRegion.span.longitudeDelta = Constant.delta
        
        anotationItems.append(PinAnnotation(coordinate: CLLocationCoordinate2D(latitude: city.lat,
                                                                               longitude: city.lon)))
    }
}

extension CityViewModel: CityViewModelProtocol {
    func fetchIcon() {
        guard let icon = section.weather.first?.icon else { return }
        iconService.fetch(iconId: icon)
            .sink { status in
                switch status {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { self.icon = $0 }
            .store(in: &cancellables)

    }
}

extension CityViewModel {
    private enum Constant {
        static let delta = 0.1
    }
}
