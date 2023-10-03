//
//  MockIconService.swift
//  CocusTuiChallenge
//
//  Created by Abraao Nascimento on 11/09/2023.
//

import Foundation
import Combine
import UIKit

class MockIconService: IconServiceProtocol {
    private var cancellables = Set<AnyCancellable>()
    var fetchDidFinishHandle: (() -> ())?
    func fetch(iconId: String) -> AnyPublisher<UIImage, Error> {
        return Just(UIImage(named: "placeholder")!)
            .tryMap({ [weak self] in
                self?.handleFinish()
                return $0
            })
            .eraseToAnyPublisher()
    }
    
    private func handleFinish() {
        if let didFinishHandle = fetchDidFinishHandle {
            didFinishHandle()
        } else {
            assertionFailure("Did finish handle not instaciated.")
        }
    }
}
