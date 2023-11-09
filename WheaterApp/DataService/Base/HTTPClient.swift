//
//  HTTPClient.swift
//  WeaterApp
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import Foundation
import Combine

protocol HTTPCLient {
    func request<T: Decodable>(endPoint: EndPoint, model: T.Type) -> AnyPublisher<T, Error>
}

extension HTTPCLient {
    func request<T: Decodable>(endPoint: EndPoint, model: T.Type) -> AnyPublisher<T, Error> {
        guard let url = handleURL(endPoint: endPoint) else {
            return Fail(error: RequestError.invalidURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw RequestError.unexpectedStatusCode
                }
                
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func handleURL(endPoint: EndPoint) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        urlComponents.query = endPoint.query
        
        guard let url = urlComponents.url else { return nil }
        return url
    }
}
