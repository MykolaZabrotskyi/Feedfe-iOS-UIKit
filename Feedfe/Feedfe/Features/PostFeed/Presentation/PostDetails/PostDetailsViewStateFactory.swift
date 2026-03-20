//
//  PostDetailsViewStateFactory.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 19.03.2026.
//

import Foundation

struct PostDetailsViewStateFactoryInput {
    let post: PostDetailsDTO
}

protocol PostDetailsViewStateFactoryProtocol {
    func make(from state: PostDetailsViewStateFactoryInput) -> PostDetailsViewState?
}

final class PostDetailsViewStateFactory {
    
    // MARK: - Properties
    
    private let dateFormatter: DateFormatterProtocol
    
    // MARK: - Init
    
    init(
        dateFormatter: DateFormatterProtocol
    ) {
        self.dateFormatter = dateFormatter
    }
}

// MARK: - PostDetailsViewStateFactoryProtocol

extension PostDetailsViewStateFactory: PostDetailsViewStateFactoryProtocol {
    func make(from state: PostDetailsViewStateFactoryInput) -> PostDetailsViewState? {
        guard
            let timestamp = state.post.timestamp,
            let title = state.post.title,
            let text = state.post.text,
            let image = state.post.image,
            let likesCount = state.post.likesCount
        else {
            return nil
        }
        
        let dateString = dateFormatter.formatRelativeDate(from: timestamp)
        return PostDetailsViewState(kind: .loaded(PostDetailsItemViewState(
            date: dateString,
            title: title,
            text: text,
            image: URL(string: image),
            likesCount: String(likesCount)
        )))
    }
}
