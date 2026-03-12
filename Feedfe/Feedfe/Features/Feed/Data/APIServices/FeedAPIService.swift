//
//  FeedAPIService.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import Foundation

protocol FeedAPIServiceProtocol {
    func fetchPosts() async throws -> FeedResponse
    func fetchDetail(with postId: String) async throws -> DetailResponse
}

final class FeedAPIService: BaseAPIService {
    
}

// MARK: - FeedAPIServiceProtocol

extension FeedAPIService: FeedAPIServiceProtocol {
    func fetchPosts() async throws -> FeedResponse {
        return try await networkService.fetch(from: FeedEndpoint.getPosts)
    }
    
    func fetchDetail(with postId: String) async throws -> DetailResponse {
        return try await networkService.fetch(from: FeedEndpoint.getPostDetail(id: postId))
    }
}
