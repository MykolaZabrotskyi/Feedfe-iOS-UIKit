//
//  PostFeedPresenter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import Foundation

enum PostFeedPresenterAction {
    case onLoad
    case onPostExpanded(postID: String)
    case onPostSelected(index: Int)
    case onDisplayModeChanged(mode: CustomTabSelectedMode)
    case onSearch(query: String)
}

protocol PostFeedPresenterProtocol: AnyObject {
    func perform(with action: PostFeedPresenterAction)
}

final class PostFeedPresenter {
    
    // MARK: - Properties
    
    private weak var viewController: PostFeedViewControllerProtocol?
    private let router: PostFeedRouterProtocol
    private let postAPIService: PostAPIServiceProtocol
    private let viewStateFactory: PostFeedViewStateFactoryProtocol
    
    private var fetchedPosts: [PostFeedDTO] = []
    private var displayedPosts: [PostFeedDTO] = []
    private var currentDisplayMode: CustomTabSelectedMode = .list
    private var expandedPostIDs: Set<String> = []
    
    private var searchTask: Task<Void, Never>?
    
    // MARK: - Init
    
    init(
        viewController: PostFeedViewControllerProtocol,
        router: PostFeedRouterProtocol,
        postAPIService: PostAPIServiceProtocol,
        viewStateFactory: PostFeedViewStateFactoryProtocol
    ) {
        self.router = router
        self.viewController = viewController
        self.postAPIService = postAPIService
        self.viewStateFactory = viewStateFactory
    }
}

// MARK: - PostFeedPresenterProtocol

extension PostFeedPresenter: PostFeedPresenterProtocol {
    func perform(with action: PostFeedPresenterAction) {
        switch action {
        case .onLoad:
            performLoadAction()
            
        case .onPostExpanded(let postID):
            performExpandAction(postID: postID)
            
        case .onPostSelected(let index):
            performSelectAction(index: index)
            
        case .onDisplayModeChanged(let mode):
            performDisplayModeChangedAction(mode: mode)
            
        case .onSearch(let query):
            performSearchAction(query: query)
        }
    }
}

// MARK: - Private Methods

private extension PostFeedPresenter {
    func performLoadAction() {
        Task {
            do {
                let response = try await postAPIService.fetchPostFeed()
                self.fetchedPosts = response.posts
                self.displayedPosts = self.fetchedPosts
                
                await MainActor.run {
                    updateViewState()
                }
            } catch {
                await MainActor.run {
                    let errorState = PostFeedViewState(kind: .error(error.localizedDescription))
                    viewController?.render(with: errorState)
                }
            }
        }
    }
    
    func performExpandAction(postID: String) {
        if expandedPostIDs.contains(postID) {
            expandedPostIDs.remove(postID)
        } else {
            expandedPostIDs.insert(postID)
        }
        
        updateViewState()
    }
    
    func performSelectAction(index: Int) {
        let selectedPostId = String(displayedPosts[index].id)
        router.routeToDetails(with: selectedPostId)
    }
    
    func performDisplayModeChangedAction(mode: CustomTabSelectedMode) {
        currentDisplayMode = mode
        updateViewState()
    }
    
    func performSearchAction(query: String) {
        searchTask?.cancel()
        
        if query.count < 2 {
            displayedPosts = fetchedPosts
            updateViewState()
        } else {
            searchTask = Task {
                do {
                    try await Task.sleep(nanoseconds: 200_000_000)
                    
                    let result = try await simulateNetworkSearch(query: query)
                    
                    await MainActor.run {
                        displayedPosts = result
                        updateViewState()
                    }
                } catch is CancellationError {
                    debugPrint(query)
                } catch {
                    await MainActor.run {
                        let errorState = PostFeedViewState(kind: .error(error.localizedDescription))
                        viewController?.render(with: errorState)
                    }
                }
            }
        }
    }
    
    func updateViewState() {
        let state = PostFeedViewStateFactoryInput(
            posts: displayedPosts,
            displayMode: currentDisplayMode,
            expandedPostIDs: expandedPostIDs
        )
        
        let viewState = viewStateFactory.make(from: state)
        
        viewController?.render(with: viewState)
    }
    
    func simulateNetworkSearch(query: String) async throws -> [PostFeedDTO] {
        try await Task.sleep(nanoseconds: 200_000_000)
        
        return fetchedPosts.filter { post in
            post.previewText?.localizedCaseInsensitiveContains(query) == true
        }
    }
    
}
