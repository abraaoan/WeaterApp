//
//  Response.swift
//  WeaterApp
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import Foundation

struct Response: Codable {
    let cod: String
    let list: [ListResult]
    let city: RCity
}
