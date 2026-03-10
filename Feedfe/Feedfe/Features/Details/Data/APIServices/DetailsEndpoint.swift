//
//  DetailsEndpoint.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import Foundation

enum DetailsEndpoint: Endpoint {
    case getPost(id: String)
    
    var baseURL: URL {
        return URL(string: "https://raw.githubusercontent.com")!
    }
    
    var path: String {
        switch self {
        case .getPost(let id):
            return "/anton-natife/jsons/master/api/posts/\(id).json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var parameters: [String: Any]? {
        return nil
    }
}

