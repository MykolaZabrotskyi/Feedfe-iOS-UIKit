//
//  FeedEndpoint.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 09.03.2026.
//

import Foundation

enum FeedEndpoint: Endpoint {
    case getPosts
    
    var baseURL: URL {
        return URL(string: "https://raw.githubusercontent.com")!
    }
    
    var path: String {
        return "/anton-natife/jsons/master/api/main.json"
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
