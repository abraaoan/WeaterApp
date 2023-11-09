//
//  RequestError.swift
//  WeaterApp
//
//  Created by Abraao Nascimento on 08/09/2023.
//

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "unauthorized error"
        default:
            return "unknown error"
        }
    }
}

enum DiskError: Error {
    case decode
    case encode
    case save
    case load
    case unknown
}
