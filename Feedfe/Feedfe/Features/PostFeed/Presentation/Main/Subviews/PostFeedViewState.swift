//
//  PostFeedViewState.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 06.03.2026.
//

import Foundation

nonisolated struct PostFeedItemViewState: Hashable {
    let id: String
    let date: String
    let title: String
    let previewText: String
    let likesCount: String
    var expandButtonTitle: String
    var isExpanded: Bool
}

nonisolated struct PostFeedViewState: Hashable {
    enum SectionType: Hashable {
        case main
    }
    
    enum SectionItem: Hashable {
        case list(PostFeedItemViewState)
        case grid(PostFeedItemViewState)
        case gallery(PostFeedItemViewState)
    }
    
    struct Section: Hashable {
        let type: SectionType
        let items: [SectionItem]
    }
    
    let sections: [Section]
}
