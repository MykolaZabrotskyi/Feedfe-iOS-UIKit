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
                guard let viewState = self.mapToViewState(from: response.post) else {
                    throw Constant.Error.corruptedData
                }
                self.post = viewState
                
                await MainActor.run {
                    self.viewController?.displayDetails(with: viewState)
                }
            } catch {
                await MainActor.run {
                    self.viewController?.displayError(error.localizedDescription) { [weak self] in
                        self?.router.popToFeed()
                    }
                }
            }
        }
    }
}

// MARK: - Private Methods

private extension PostDetailsPresenter {
    func mapToViewState(from dto: PostDetailsDTO) -> PostDetailsViewState? {
        guard
            let timestamp = dto.timestamp,
            let title = dto.title,
            let text = dto.text,
            let image = dto.image,
            let likesCount = dto.likesCount
        else {
            return nil
        }
        
        let dateString = dateFormatter.formatRelativeDate(from: timestamp)
        return PostDetailsViewState(
            date: dateString,
            title: title,
            text: text,
            image: URL(string: image),
            likesCount: String(likesCount)
        )
    }
}

// MARK: - Constants

private extension PostDetailsPresenter {
    enum Constant {
        enum Error: LocalizedError {
            case corruptedData
            
            var errorDescription: String? {
                switch self {
                case .corruptedData:
                    return "Unable to load post details. Data is corrupt."
                }
            }
        }
    }
}
