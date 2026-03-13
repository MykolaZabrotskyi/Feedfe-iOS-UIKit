//
//  PostFeedDTO.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

struct PostFeedDTO: Codable {
    let id: Int
    let timestamp: Int
    let title: String
    let previewText: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case timestamp = "timeshamp"
        case title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}
