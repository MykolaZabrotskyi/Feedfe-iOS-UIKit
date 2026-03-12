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

final class DetailsPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: DetailsViewControllerProtocol?
    private let router: DetailsRouterProtocol
    private let postId: String
    private let feedAPIService: FeedAPIServiceProtocol
    private let dateFormatter: DateFormatterProtocol
    
    private var post: PostDetailViewState?
    
    // MARK: - Init
    
    init(
        viewController: DetailsViewControllerProtocol,
        router: DetailsRouterProtocol,
        postId: String,
        dateFormatter: DateFormatterProtocol,
        feedAPIService: FeedAPIServiceProtocol
    ) {
        self.router = router
        self.viewController = viewController
        self.postId = postId
        self.dateFormatter = dateFormatter
        self.feedAPIService = feedAPIService
    }
}

// MARK: - DetailsPresenterProtocol

extension DetailsPresenter: DetailsPresenterProtocol {
    func fetchPostDetails() {
        Task {
            do {
                let response = try await feedAPIService.fetchDetail(with: postId)
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
        let dateString = dateFormatter.formatRelativeDate(from: post.timestamp)
        
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
