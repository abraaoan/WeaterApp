//
//  ImageService.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 08/09/2023.
//

import Foundation
import UIKit
import Combine

protocol IconServiceProtocol {
    func fetch(iconId: String) -> AnyPublisher<UIImage, Error>
}

class IconService: IconServiceProtocol {
    private static let imageCache = NSCache<NSString, UIImage>()
    private var cancellables = Set<AnyCancellable>()
    
    func fetch(iconId: String) -> AnyPublisher<UIImage, Error> {
        if let cachedImage = Self.imageCache.object(forKey: iconId as NSString) {
            return Just(cachedImage).tryMap{ $0 }.eraseToAnyPublisher()
        } else {
            return request(endPoint: WeatherIconAPI.icon(iconId: iconId))
                .compactMap {
                    guard let image = UIImage(data: $0) else { return nil }
                    Self.imageCache.setObject(image, forKey: iconId as NSString)
                    return image
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func request(endPoint: EndPoint) -> AnyPublisher<Data, Error> {
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
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    private func handleURL(endPoint: EndPoint) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        
        guard let url = urlComponents.url else { return nil }
        return url
    }
}
