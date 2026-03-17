//
//  PostFeedPresenter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import Foundation

protocol PostFeedPresenterProtocol: AnyObject {
    var postsCount: Int { get }
    func fetchPostFeed()
    func toggleExpand(at index: Int)
    func didSelectPost(at index: Int)
    func didChangeDisplayMode(to mode: PostFeedCellType)
}

final class PostFeedPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: PostFeedViewControllerProtocol?
    private let router: PostFeedRouterProtocol
    private let postAPIService: PostAPIServiceProtocol
    private let dateFormatter: DateFormatterProtocol
    
    private var posts: [PostFeedItemViewState] = []
    private var currentDisplayMode: PostFeedCellType = .list
    
    // MARK: - Init
    
    init(
        viewController: PostFeedViewControllerProtocol,
        router: PostFeedRouterProtocol,
        postAPIService: PostAPIServiceProtocol,
        dateFormatter: DateFormatterProtocol
    ) {
        self.router = router
        self.viewController = viewController
        self.postAPIService = postAPIService
        self.dateFormatter = dateFormatter
    }
}

// MARK: - PostFeedPresenterProtocol

extension PostFeedPresenter: PostFeedPresenterProtocol {
    var postsCount: Int {
        return posts.count
    }
    
    func fetchPostFeed() {
        Task {
            do {
                let response = try await postAPIService.fetchPostFeed()
                self.posts = response.posts.compactMap { self.mapToCellModel(from: $0) }
                
                await MainActor.run {
                    self.updateViewState()
                }
            } catch {
                await MainActor.run {
                    self.viewController?.displayError(error.localizedDescription)
                }
            }
        }
    }
    
    func didChangeDisplayMode(to mode: PostFeedCellType) {
        currentDisplayMode = mode
        updateViewState()
    }
    
    func toggleExpand(at index: Int) {
        posts[index].isExpanded.toggle()
        posts[index].expandButtonTitle = posts[index].isExpanded ? Constant.Text.collapse : Constant.Text.expand
        updateViewState()
    }
    
    func didSelectPost(at index: Int) {
        let selectedPostId = posts[index].id
        router.routeToDetails(with: selectedPostId)
    }
}

// MARK: - Private Methods

private extension PostFeedPresenter {
    func mapToCellModel(from dto: PostFeedDTO) -> PostFeedItemViewState? {
        guard
            let timestamp = dto.timestamp,
            let title = dto.title,
            let previewText = dto.previewText,
            let likesCount = dto.likesCount
        else {
            return nil
        }
        
        let dateString = dateFormatter.formatRelativeDate(from: timestamp)
        return PostFeedItemViewState(
            id: String(dto.id),
            date: dateString,
            title: title,
            previewText: previewText,
            likesCount: String(likesCount),
            expandButtonTitle: Constant.Text.expand,
            isExpanded: false
        )
    }
    
    func updateViewState() {
        let sectionItems: [PostFeedViewState.SectionItem] = posts.map { post in
            switch currentDisplayMode {
            case .list:
                return .list(post)
                
            case .grid:
                return .grid(post)
                
            case .gallery:
                return .gallery(post)
            }
        }
        
        let section = PostFeedViewState.Section(type: .main, items: sectionItems)
        let viewState = PostFeedViewState(sections: [section])
        viewController?.displayPosts(with: viewState)
    }
}

// MARK: - Constant

private extension PostFeedPresenter {
    enum Constant {
        enum Text {
            static let collapse = "Collapse"
            static let expand = "Expand"
        }
    }
}
