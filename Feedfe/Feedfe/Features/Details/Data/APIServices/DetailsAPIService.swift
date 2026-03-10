//
//  DetailsAPIService.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import Foundation

protocol DetailsAPIServiceProtocol {
    func fetchPosts(id: String) async throws -> DetailResponse
}

final class DetailsAPIService: BaseAPIService {

}

// MARK: - DetailsAPIServiceProtocol

extension DetailsAPIService: DetailsAPIServiceProtocol {
    func fetchPosts(id: String) async throws -> DetailResponse {
        return try await networkService.fetch(from: DetailsEndpoint.getPost(id: id))
    }
}
