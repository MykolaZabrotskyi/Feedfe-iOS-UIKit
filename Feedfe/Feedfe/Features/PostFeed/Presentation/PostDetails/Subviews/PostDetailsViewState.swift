//
//  PostDetailsViewState.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import Foundation

struct PostDetailsViewState {
    typealias Item = PostDetailsItemViewState
    
    enum Kind {
        case error(String)
        case loaded(Item)
    }
    
    let kind: Kind
}
