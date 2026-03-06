//
//  NetworkService.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

protocol NetworkServiceProtocol: AnyObject {
    func request(method: HTTPMethod, urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkService {
    
}

// MARK: - NetworkServiceProtocol

extension NetworkService: NetworkServiceProtocol {
    func request(method: HTTPMethod, urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.invalidURL))
            }
            
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                
                return
            }
            guard let data else {
                completion(.failure(NetworkError.noData))
                
                return
            }
            completion(.success(data))
        }.resume()
    }
}
