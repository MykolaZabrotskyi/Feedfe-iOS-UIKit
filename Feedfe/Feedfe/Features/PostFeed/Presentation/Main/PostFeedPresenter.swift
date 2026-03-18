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
    private let dateFormatter: DateFormatterProtocol
    
    private var fetchedPosts: [PostFeedItemViewState] = []
    private var displayedPosts: [PostFeedItemViewState] = []
    private var currentDisplayMode: CustomTabSelectedMode = .list
    
    private var searchTask: Task<Void, Never>?
    
    // MARK: - Init
    
    init(
        viewController: PostFeedViewControllerProtocol,
        router: PostFeedRouterProtocol,
        postAPIService: PostAPIServiceProtocol,
        dateFormatter: DateFormatterProtocol
    ) {
        self.router = router
        self.viewController = viewController
        self.postAPIService = postAPIService
        self.dateFormatter = dateFormatter
    }
}

// MARK: - PostFeedPresenterProtocol

extension PostFeedPresenter: PostFeedPresenterProtocol {
    func fetchPostFeed() {
        Task {
            do {
                let response = try await postAPIService.fetchPostFeed()
                fetchedPosts = response.posts.compactMap { self.mapToCellModel(from: $0) }
                
                displayedPosts = fetchedPosts
                
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
        guard
            let indexInCurrentPosts = displayedPosts.firstIndex(where: { $0.id == postID }),
            let indexInAllPosts = fetchedPosts.firstIndex(where: { $0.id == postID })
        else {
            return
        }
        
        displayedPosts[indexInCurrentPosts].isExpanded.toggle()
        displayedPosts[indexInCurrentPosts].expandButtonTitle = displayedPosts[indexInCurrentPosts].isExpanded
        ? Constant.Text.collapse
        : Constant.Text.expand
        
        fetchedPosts[indexInAllPosts] = displayedPosts[indexInCurrentPosts]
        
        updateViewState()
    }
    
    func didSelectPost(at index: Int) {
        let selectedPostId = displayedPosts[index].id
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
    func mapToCellModel(from dto: PostFeedDTO) -> PostFeedItemViewState? {
        guard
            let timestamp = dto.timestamp,
            let title = dto.title,
            let previewText = dto.previewText,
            let likesCount = dto.likesCount
        else {
            return nil
        }
        
        let dateString = dateFormatter.formatRelativeDate(from: timestamp)
        return PostFeedItemViewState(
            id: String(dto.id),
            date: dateString,
            title: title,
            previewText: previewText,
            likesCount: String(likesCount),
            expandButtonTitle: Constant.Text.expand,
            isExpanded: false
        )
    }
    
    func updateViewState() {
        let sectionType: PostFeedViewState.SectionType
        switch currentDisplayMode {
        case .list: sectionType = .list
            
        case .grid: sectionType = .grid
            
        case .gallery: sectionType = .gallery
        }
        
        let section = PostFeedViewState.Section(type: sectionType, items: displayedPosts)
        let viewState = PostFeedViewState(sections: [section])
        viewController?.render(with: viewState)
    }
    
    func simulateNetworkSearch(query: String) async throws -> [PostFeedItemViewState] {
        try await Task.sleep(nanoseconds: 200_000_000)
        
        return fetchedPosts.filter { post in
            post.previewText.localizedCaseInsensitiveContains(query)
        }
    }
    
}

// MARK: - Constant

private extension PostFeedPresenter {
    enum Constant {
        enum Text {
            static let collapse = "Collapse"
            static let expand = "Expand"
        }
    }
}
