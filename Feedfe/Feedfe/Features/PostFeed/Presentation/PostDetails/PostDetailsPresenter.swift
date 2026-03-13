//
//  PostDetailsPresenter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import Foundation

protocol PostDetailsPresenterProtocol: AnyObject {
    func fetchPostDetails()
}

final class PostDetailsPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: PostDetailsViewControllerProtocol?
    private let router: PostDetailsRouterProtocol
    private let postAPIService: PostAPIServiceProtocol
    private let dateFormatter: DateFormatterProtocol
    
    private let postID: String
    private var post: PostDetailsViewState?
    
    // MARK: - Init
    
    init(
        viewController: PostDetailsViewControllerProtocol,
        router: PostDetailsRouterProtocol,
        postID: String,
        dateFormatter: DateFormatterProtocol,
        postAPIService: PostAPIServiceProtocol
    ) {
        self.router = router
        self.viewController = viewController
        self.postID = postID
        self.dateFormatter = dateFormatter
        self.postAPIService = postAPIService
    }
}

// MARK: - PostDetailsPresenterProtocol

extension PostDetailsPresenter: PostDetailsPresenterProtocol {
    func fetchPostDetails() {
        Task {
            do {
                let response = try await postAPIService.fetchPostDetails(with: postID)
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

private extension PostDetailsPresenter {
    func mapToViewState(from dto: PostDetailsDTO) -> PostDetailsViewState {
        let dateString = dateFormatter.formatRelativeDate(from: dto.timestamp)
        return PostDetailsViewState(
            date: dateString,
            title: dto.title,
            text: dto.text,
            image: URL(string: dto.image),
            likesCount: String(dto.likesCount)
        )
    }
}
