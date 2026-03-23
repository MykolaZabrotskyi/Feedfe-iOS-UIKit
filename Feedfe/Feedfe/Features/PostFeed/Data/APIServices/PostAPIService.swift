//
//  PostAPIService.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import Foundation

protocol PostAPIServiceProtocol {
    func fetchPostFeed() async throws -> PostFeedResponse
    func fetchPostDetails(with postId: String) async throws -> PostDetailsResponse
}

final class PostAPIService: BaseAPIService {
    
}

// MARK: - PostAPIServiceProtocol

extension PostAPIService: PostAPIServiceProtocol {
    func fetchPostFeed() async throws -> PostFeedResponse {
        return try await networkService.fetch(from: PostEndpoint.getPostFeed)
    }
    
    func fetchPostDetails(with postId: String) async throws -> PostDetailsResponse {
        return try await networkService.fetch(from: PostEndpoint.getPostDetails(id: postId))
    }
}
