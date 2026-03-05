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
    func getPost(at index: Int) -> PostFeedModel
}

final class PostFeedPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: PostFeedViewControllerProtocol?
    private let router: PostFeedRouterProtocol
    private let networkAPIService: PostFeedAPIServiceProtocol
    
    private var posts: [PostFeedModel] = []
    
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
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedPosts):
                self.posts = fetchedPosts
                self.viewController?.displayPosts()
                
            case .failure(let error):
                self.viewController?.displayError(error.localizedDescription)
            }
        }
    }
    
    func getPost(at index: Int) -> PostFeedModel {
        return posts[index]
    }
}
