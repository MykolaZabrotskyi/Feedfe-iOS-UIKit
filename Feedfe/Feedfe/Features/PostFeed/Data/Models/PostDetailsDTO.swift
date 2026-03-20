//
//  PostDetailsDTO.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 13.03.2026.
//

struct PostDetailsDTO: Codable {
    let id: Int
    let timestamp: Int?
    let title: String?
    let text: String?
    let image: String?
    let likesCount: Int?

    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case timestamp = "timeshamp"
        case title
        case text
        case image = "postImage"
        case likesCount = "likes_count"
    }
}
