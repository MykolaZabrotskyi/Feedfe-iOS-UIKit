//
//  PostFeedModel.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import Foundation

struct PostFeedResponse: Codable {
    let posts: [PostFeed]
}

struct PostFeed: Codable {
    let postId: Int
    let timestamp: Int
    let title: String
    let previewText: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case timestamp = "timeshamp"
        case title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}
