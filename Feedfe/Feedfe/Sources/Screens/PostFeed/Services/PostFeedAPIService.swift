//
//  PostFeedAPIService.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import Foundation

protocol PostFeedAPIServiceProtocol {
    func fetchPosts(completion: @escaping (Result<PostFeedResponse, Error>) -> Void)
}

final class PostFeedAPIService: PostFeedAPIServiceProtocol {
    
    // MARK: - Properties
    
    private let networkService: NetworkServiceProtocol
    
    private let feedURL = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json"
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Internal Methods
    
    func fetchPosts(completion: @escaping (Result<PostFeedResponse, Error>) -> Void) {
        networkService.request(method: .get, urlString: feedURL) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(PostFeedResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.decodingError))
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
