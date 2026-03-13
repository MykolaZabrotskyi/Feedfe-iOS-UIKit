//
//  PostEndpoint.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 09.03.2026.
//

import Foundation

enum PostEndpoint: Endpoint {
    case getPostFeed
    case getPostDetails(id: String)
    
    var baseURL: URL {
        return URL(string: "https://raw.githubusercontent.com")!
    }
    
    var path: String {
        switch self {
        case .getPostFeed:
            return "/anton-natife/jsons/master/api/main.json"
            
        case .getPostDetails(let id):
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
