//
//  PostDetailsPresenter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import Foundation

enum PostDetailsPresenterAction {
    case onLoad
    case onErrorTapped
}

protocol PostDetailsPresenterProtocol: AnyObject {
    func perform(with action: PostDetailsPresenterAction)
}

final class PostDetailsPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: PostDetailsViewControllerProtocol?
    private let router: PostDetailsRouterProtocol
    private let postAPIService: PostAPIServiceProtocol
    private let viewStateFactory: PostDetailsViewStateFactoryProtocol
    
    private let postID: String
    private var post: PostDetailsDTO?
    
    // MARK: - Init
    
    init(
        viewController: PostDetailsViewControllerProtocol,
        router: PostDetailsRouterProtocol,
        postID: String,
        postAPIService: PostAPIServiceProtocol,
        viewStateFactory: PostDetailsViewStateFactoryProtocol
    ) {
        self.router = router
        self.viewController = viewController
        self.postID = postID
        self.postAPIService = postAPIService
        self.viewStateFactory = viewStateFactory
    }
}

// MARK: - PostDetailsPresenterProtocol

extension PostDetailsPresenter: PostDetailsPresenterProtocol {
    func perform(with action: PostDetailsPresenterAction) {
        switch action {
        case .onLoad:
            performLoadAction()
            
        case .onErrorTapped:
            performErrorTapped()
        }
    }
}

// MARK: - Private Methods

private extension PostDetailsPresenter {
    func performLoadAction() {
        Task {
            do {
                let response = try await postAPIService.fetchPostDetails(with: postID)
                let state = PostDetailsViewStateFactoryInput(post: response.post)
                guard let viewState = self.viewStateFactory.make(from: state) else {
                    throw Constant.Error.corruptedData
                }
                
                self.post = response.post
                
                await MainActor.run {
                    self.viewController?.render(with: viewState)
                }
            } catch {
                await MainActor.run {
                    let errorState = PostDetailsViewState(kind: .error(error.localizedDescription))
                    self.viewController?.render(with: errorState)
                }
            }
        }
    }
    
    func performErrorTapped() {
        router.popToFeed()
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
