//
//  NetworkService.swift
//
//  Created by Gökhan VARIŞ / Adapted by Mykola Zabrotskyi
//
//  https://medium.com/@gokhanvaris/creating-a-network-manager-in-swiftui-with-clean-code-principles-d767a0e93a9a

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T
}

final class NetworkService {
    
    // MARK: - Properties
    
    private let session: URLSession
    
    // MARK: - Init
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

// MARK: - NetworkServiceProtocol

extension NetworkService: NetworkServiceProtocol {
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T {
        let request = try endpoint.urlRequest()
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        try validateResponse(httpResponse)
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}

// MARK: - Private Methods

private extension NetworkService {
    private func validateResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 400...499:
            throw NetworkError.clientError(response.statusCode)
        case 500...599:
            throw NetworkError.serverError(response.statusCode)
        default:
            throw NetworkError.unknownError(response.statusCode)
        }
    }
}
