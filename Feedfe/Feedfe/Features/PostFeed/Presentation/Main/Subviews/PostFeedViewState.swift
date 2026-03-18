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
    
    typealias SectionItem = PostFeedItemViewState
    
    struct Section: Hashable {
        let type: SectionType
        let items: [SectionItem]
    }
    
    let sections: [Section]
}
