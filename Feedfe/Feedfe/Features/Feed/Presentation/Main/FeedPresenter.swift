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
    func getPost(at index: Int) -> FeedTableViewCellState
    func toggleExpand(at index: Int)
}

final class FeedPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: FeedViewControllerProtocol?
    private let router: FeedRouterProtocol
    private let networkAPIService: FeedAPIServiceProtocol
    
    private var posts: [FeedTableViewCellState] = []
    
    private static let relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
    
    // MARK: - Init
    
    init(
        viewController: FeedViewControllerProtocol,
        router: FeedRouterProtocol,
        networkAPIService: FeedAPIServiceProtocol
    ) {
        self.router = router
        self.viewController = viewController
        self.networkAPIService = networkAPIService
    }
}

// MARK: - PostFeedPresenterProtocol

extension FeedPresenter: FeedPresenterProtocol {
    var postsCount: Int {
        return posts.count
    }
    
    func fetchPostFeed() {
        Task {
            do {
                let response = try await networkAPIService.fetchPosts()
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
    
    func getPost(at index: Int) -> FeedTableViewCellState {
        return posts[index]
    }
    
    func toggleExpand(at index: Int) {
        posts[index].isExpanded.toggle()
        posts[index].expandButtonTitle = posts[index].isExpanded ? Constant.Text.collapse : Constant.Text.expand
        viewController?.updateRow(at: index, with: posts[index].expandButtonTitle)
    }
}

// MARK: - Private Methods

private extension FeedPresenter {
    func mapToCellModel(from model: PostFeed) -> FeedTableViewCellState {
        let date = Date(timeIntervalSince1970: TimeInterval(model.timestamp))
        
        let dateString = Self.relativeDateFormatter.localizedString(for: date, relativeTo: Date())
        
        return FeedTableViewCellState(
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
