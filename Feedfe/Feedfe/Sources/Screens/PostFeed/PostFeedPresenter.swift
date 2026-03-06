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
    func getPost(at index: Int) -> PostFeedCell
    func toggleExpand(at index: Int)
}

final class PostFeedPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: PostFeedViewControllerProtocol?
    private let router: PostFeedRouterProtocol
    private let networkAPIService: PostFeedAPIServiceProtocol
    
    private var posts: [PostFeedCell] = []
    
    // MARK: - Init
    
    init(viewController: PostFeedViewControllerProtocol, router: PostFeedRouterProtocol, networkAPIService: PostFeedAPIServiceProtocol) {
        self.router = router
        self.viewController = viewController
        self.networkAPIService = networkAPIService
    }
}

// MARK: - PostFeedPresenterProtocol

extension PostFeedPresenter: PostFeedPresenterProtocol {
    var postsCount: Int {
        return posts.count
    }
    
    func fetchPostFeed() {
        networkAPIService.fetchPosts { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case .success(let response):
                self.posts = response.posts.map { self.mapToCellModel(from: $0) }
                self.viewController?.displayPosts()
                
            case .failure(let error):
                self.viewController?.displayError(error.localizedDescription)
            }
        }
    }
    
    func getPost(at index: Int) -> PostFeedCell {
        return posts[index]
    }
    
    func toggleExpand(at index: Int) {
        posts[index].isExpanded.toggle()
        viewController?.updateRow(at: index)
    }
}

// MARK: - Private Methods

private extension PostFeedPresenter {
    private func mapToCellModel(from model: PostFeed) -> PostFeedCell {
        let date = Date(timeIntervalSince1970: TimeInterval(model.timestamp))
        let formatter = RelativeDateTimeFormatter()
        
        formatter.unitsStyle = .full
        
        let dateString = formatter.localizedString(for: date, relativeTo: Date())
        
        return PostFeedCell(
            postId: String(model.postId),
            timestamp: dateString,
            title: model.title,
            previewText: model.previewText,
            likesCount: String(model.likesCount),
            isExpanded: false
        )
    }
}
