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
        guard let url = URL(string: "https://raw.githubusercontent.com") else {
            fatalError("Can't create url")
        }
        return url
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
}
