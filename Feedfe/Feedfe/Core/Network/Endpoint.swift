//
//  Endpoint.swift
//
//  Created by Gökhan VARIŞ
//
//  https://medium.com/@gokhanvaris/creating-a-network-manager-in-swiftui-with-clean-code-principles-d767a0e93a9a

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

extension Endpoint {
    func urlRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let parameters = parameters {
            if method == .get {
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                
                request.url = components?.url
            } else {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            }
        }
        
        return request
    }
}
