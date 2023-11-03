//
//  RequestState.swift
//  WheaterApp
//
//  Created by Abraao Nascimento on 25/10/2023.
//

enum RequestState: Equatable {
    case initial
    case empty
    case failure(Error)
    case loading
    case success
    
    static func == (lhs: RequestState, rhs: RequestState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial): return true
        case (.empty, .empty): return true
        case (let .failure(lhsError), let .failure(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.loading, .loading): return true
        case (.success, .success): return true
        default: return false
        }
    }
}
