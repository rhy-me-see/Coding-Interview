//
//  SearchService.swift
//  TypeSearch
//
//  Created by Ruohua Yin on 4/16/25.
//

import Combine
import Foundation

// MARK: - Mock Service

protocol SearchServiceProtocol {
    func search(query: String) -> AnyPublisher<[String], Never>
}

class MockSearchService: SearchServiceProtocol {
    private let dataset = ["Sushi", "Salad", "Sandwich", "Soup", "Steak", "Steamed Rice", "Samosa", "Spaghetti"]
    
    func search(query: String) -> AnyPublisher<[String], Never> {
        let result = dataset.filter { $0.lowercased().hasPrefix(query.lowercased()) }
        return Just(result)
            .delay(for: .milliseconds(300), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
