//
//  DetailsPresenter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import Foundation

protocol DetailsPresenterProtocol: AnyObject {
    func fetchPostDetails()
}

final class DetailsPresenter: BasePresenter {
    
    // MARK: - Properties
    
    private weak var viewController: DetailsViewControllerProtocol?
    private let router: DetailsRouterProtocol
    private let networkAPIService: DetailsAPIServiceProtocol
    private let postId: String
    
    private var post: PostDetailViewState?
    
    // MARK: - Init
    
    init(
        viewController: DetailsViewControllerProtocol,
        router: DetailsRouterProtocol,
        networkAPIService: DetailsAPIServiceProtocol,
        postId: String
    ) {
        self.router = router
        self.viewController = viewController
        self.networkAPIService = networkAPIService
        self.postId = postId
    }
}

// MARK: - DetailsPresenterProtocol

extension DetailsPresenter: DetailsPresenterProtocol {
    func fetchPostDetails() {
        Task {
            do {
                let response = try await networkAPIService.fetchPosts(id: postId)
                let viewState = self.mapToViewState(from: response.post)
                self.post = viewState
                
                await MainActor.run {
                    self.viewController?.displayDetails(with: viewState)
                }
            } catch {
                await MainActor.run {
                    self.viewController?.displayError(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Private Methods

private extension DetailsPresenter {
    func mapToViewState(from post: PostDetail) -> PostDetailViewState {
        let date = Date(timeIntervalSince1970: TimeInterval(post.timestamp))
        
        let dateString = Self.relativeDateFormatter.localizedString(for: date, relativeTo: Date())
        
        return PostDetailViewState(
            timestamp: dateString,
            title: post.title,
            text: post.text,
            postImage: URL(string: post.postImage),
            likesCount: String(post.likesCount)
        )
    }
}

private extension DetailsPresenter {
    enum Constant {
        
    }
}
