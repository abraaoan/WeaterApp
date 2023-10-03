//
//  Weater.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
