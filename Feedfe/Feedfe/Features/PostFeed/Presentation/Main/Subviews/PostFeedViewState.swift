//
//  PostFeedViewState.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 06.03.2026.
//

import Foundation

nonisolated struct PostFeedViewState: Hashable {
    enum SectionType: Hashable {
        case list
        case grid
        case gallery
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
