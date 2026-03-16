//
//  PostFeedViewState.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 06.03.2026.
//

struct PostFeedViewState: Hashable {
    let id: String
    let date: String
    let title: String
    let previewText: String
    let likesCount: String
    var expandButtonTitle: String
    var isExpanded: Bool
}
