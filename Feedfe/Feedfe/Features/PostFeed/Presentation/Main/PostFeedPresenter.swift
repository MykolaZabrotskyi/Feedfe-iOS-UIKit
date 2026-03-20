//
//  PostFeedPresenter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import Foundation

protocol PostFeedPresenterProtocol: AnyObject {
    func fetchPostFeed()
    func toggleExpand(at postID: String)
    func didSelectPost(at index: Int)
    func didChangeDisplayMode(to mode: CustomTabSelectedMode)
    func search(with query: String)
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
    func fetchPostFeed() {
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
                    viewController?.displayError(error.localizedDescription)
                }
            }
        }
    }
    
    func didChangeDisplayMode(to mode: CustomTabSelectedMode) {
        currentDisplayMode = mode
        updateViewState()
    }
    
    func toggleExpand(at postID: String) {
        if expandedPostIDs.contains(postID) {
            expandedPostIDs.remove(postID)
        } else {
            expandedPostIDs.insert(postID)
        }
        
        updateViewState()
    }
    
    func didSelectPost(at index: Int) {
        let selectedPostId = String(displayedPosts[index].id)
        router.routeToDetails(with: selectedPostId)
    }
    
    func search(with query: String) {
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
                        viewController?.displayError(error.localizedDescription)
                    }
                }
            }
        }
    }
}

// MARK: - Private Methods

private extension PostFeedPresenter {
    func updateViewState() {
        let state = PostFeedState(
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
