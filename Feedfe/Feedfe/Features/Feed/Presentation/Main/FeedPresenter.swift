//
//  FeedPresenter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import Foundation

protocol FeedPresenterProtocol: AnyObject {
    var postsCount: Int { get }
    func fetchPostFeed()
    func getPost(at index: Int) -> FeedTableViewState
    func toggleExpand(at index: Int)
    func didSelectPost(at index: Int)
}

final class FeedPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: FeedViewControllerProtocol?
    private let router: FeedRouterProtocol
    private let feedAPIService: FeedAPIServiceProtocol
    private let dateFormatter: DateFormatterProtocol
    
    private var posts: [FeedTableViewState] = []
    
    // MARK: - Init
    
    init(
        viewController: FeedViewControllerProtocol,
        router: FeedRouterProtocol,
        feedAPIService: FeedAPIServiceProtocol,
        dateFormatter: DateFormatterProtocol
    ) {
        self.router = router
        self.viewController = viewController
        self.feedAPIService = feedAPIService
        self.dateFormatter = dateFormatter
    }
}

// MARK: - FeedPresenterProtocol

extension FeedPresenter: FeedPresenterProtocol {
    var postsCount: Int {
        return posts.count
    }
    
    func fetchPostFeed() {
        Task {
            do {
                let response = try await feedAPIService.fetchPosts()
                self.posts = response.posts.map { self.mapToCellModel(from: $0) }
                
                await MainActor.run {
                    self.viewController?.displayPosts()
                }
            } catch {
                await MainActor.run {
                    self.viewController?.displayError(error.localizedDescription)
                }
            }
        }
    }
    
    func getPost(at index: Int) -> FeedTableViewState {
        return posts[index]
    }
    
    func toggleExpand(at index: Int) {
        posts[index].isExpanded.toggle()
        posts[index].expandButtonTitle = posts[index].isExpanded ? Constant.Text.collapse : Constant.Text.expand
        viewController?.updateRow(at: index, with: posts[index].expandButtonTitle)
    }
    
    func didSelectPost(at index: Int) {
        let selectedPostId = posts[index].postId
        
        router.routeToDetails(with: selectedPostId)
    }
}

// MARK: - Private Methods

private extension FeedPresenter {
    func mapToCellModel(from model: PostFeed) -> FeedTableViewState {
        let dateString = dateFormatter.formatRelativeDate(from: model.timestamp)
        
        return FeedTableViewState(
            postId: String(model.postId),
            timestamp: dateString,
            title: model.title,
            previewText: model.previewText,
            likesCount: String(model.likesCount),
            expandButtonTitle: Constant.Text.expand,
            isExpanded: false
        )
    }
}

private extension FeedPresenter {
    enum Constant {
        enum Text {
            static let collapse = "Collapse"
            static let expand = "Expand"
        }
    }
}
