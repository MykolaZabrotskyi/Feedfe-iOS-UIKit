//
//  PostDetail.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

struct PostDetail: Codable {
    let postId: Int
    let timestamp: Int
    let title: String
    let text: String
    let postImage: String
    let likesCount: Int

    enum CodingKeys: String, CodingKey {
        case postId
        case timestamp = "timeshamp"
        case title, text, postImage
        case likesCount = "likes_count"
    }
}
