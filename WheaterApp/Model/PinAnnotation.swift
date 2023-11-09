//
//  PinAnnotation.swift
//  WeaterApp
//
//  Created by Abraao Nascimento on 11/09/2023.
//

import Foundation
import MapKit

struct PinAnnotation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}
