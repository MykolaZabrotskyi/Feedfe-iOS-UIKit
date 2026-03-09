//
//  FeedAPIService.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import Foundation

protocol FeedAPIServiceProtocol {
    func fetchPosts() async throws -> FeedResponse
}

final class FeedAPIService {
    
    // MARK: - Properties
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

// MARK: - FeedAPIServiceProtocol

extension FeedAPIService: FeedAPIServiceProtocol {
    func fetchPosts() async throws -> FeedResponse {
        return try await networkService.fetch(from: FeedEndpoint.getPosts)
    }
}
