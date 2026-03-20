//
//  PostFeedViewStateFactory.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 19.03.2026.
//

struct PostFeedViewStateFactoryInput {
    let posts: [PostFeedDTO]
    let displayMode: CustomTabSelectedMode
    let expandedPostIDs: Set<String>
}

protocol PostFeedViewStateFactoryProtocol {
    func make(from state: PostFeedViewStateFactoryInput) -> PostFeedViewState
}

final class PostFeedViewStateFactory {
    
    // MARK: - Properties
    
    private let dateFormatter: DateFormatterProtocol
    
    // MARK: - Init
    
    init(
        dateFormatter: DateFormatterProtocol
    ) {
        self.dateFormatter = dateFormatter
    }
}

// MARK: - PostFeedViewStateFactoryProtocol

extension PostFeedViewStateFactory: PostFeedViewStateFactoryProtocol {
    func make(from state: PostFeedViewStateFactoryInput) -> PostFeedViewState {
        let sectionItems = state.posts.compactMap {
            mapToItemViewState(from: $0, expandedPostIDs: state.expandedPostIDs)
        }
        
        let sectionType: PostFeedViewState.SectionType
        switch state.displayMode {
        case .list:
            sectionType = .list
        case .grid:
            sectionType = .grid
        case .gallery:
            sectionType = .gallery
        }
        
        let section = PostFeedViewState.Section(type: sectionType, items: sectionItems)
        return PostFeedViewState(kind: .loaded([section]))
    }
}

// MARK: - Private Methods

private extension PostFeedViewStateFactory {
    func mapToItemViewState(from dto: PostFeedDTO, expandedPostIDs: Set<String>) -> PostFeedItemViewState? {
        guard
            let timestamp = dto.timestamp,
            let title = dto.title,
            let previewText = dto.previewText,
            let likesCount = dto.likesCount
        else {
            return nil
        }
        
        let id = String(dto.id)
        let isExpanded = expandedPostIDs.contains(id)
        let expandButtonTitle = isExpanded ? Constant.Text.collapse : Constant.Text.expand
        let dateString = dateFormatter.formatRelativeDate(from: timestamp)
        
        return PostFeedItemViewState(
            id: id,
            date: dateString,
            title: title,
            previewText: previewText,
            likesCount: String(likesCount),
            expandButtonTitle: expandButtonTitle,
            isExpanded: isExpanded
        )
    }
}

// MARK: - Constant

private extension PostFeedViewStateFactory {
    enum Constant {
        enum Text {
            static let collapse = "Collapse"
            static let expand = "Expand"
        }
    }
}
