//
//  EndPoint.swift
//  WeaterApp
//
//  Created by Abraao Nascimento on 08/09/2023.
//

protocol EndPoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var query: String? { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension EndPoint {
    var scheme: String { "http" }
}
