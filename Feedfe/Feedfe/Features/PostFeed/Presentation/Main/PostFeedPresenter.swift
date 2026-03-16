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
    func getPost(at index: Int) -> PostFeedViewState
    func toggleExpand(at index: Int)
    func didSelectPost(at index: Int)
}

final class PostFeedPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: PostFeedViewControllerProtocol?
    private let router: PostFeedRouterProtocol
    private let postAPIService: PostAPIServiceProtocol
    private let dateFormatter: DateFormatterProtocol
    
    private var posts: [PostFeedViewState] = []
    
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
                    self.viewController?.displayPosts(with: self.posts)
                }
            } catch {
                await MainActor.run {
                    self.viewController?.displayError(error.localizedDescription)
                }
            }
        }
    }
    
    func getPost(at index: Int) -> PostFeedViewState {
        return posts[index]
    }
    
    func toggleExpand(at index: Int) {
        posts[index].isExpanded.toggle()
        posts[index].expandButtonTitle = posts[index].isExpanded ? Constant.Text.collapse : Constant.Text.expand
        viewController?.displayPosts(with: posts)
    }
    
    func didSelectPost(at index: Int) {
        let selectedPostId = posts[index].id
        router.routeToDetails(with: selectedPostId)
    }
}

// MARK: - Private Methods

private extension PostFeedPresenter {
    func mapToCellModel(from dto: PostFeedDTO) -> PostFeedViewState? {
        guard
            let timestamp = dto.timestamp,
            let title = dto.title,
            let previewText = dto.previewText,
            let likesCount = dto.likesCount
        else {
            return nil
        }
        
        let dateString = dateFormatter.formatRelativeDate(from: timestamp)
        return PostFeedViewState(
            id: String(dto.id),
            date: dateString,
            title: title,
            previewText: previewText,
            likesCount: String(likesCount),
            expandButtonTitle: Constant.Text.expand,
            isExpanded: false
        )
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
