//
//  FeedRouter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import UIKit

protocol FeedRouterProtocol: AnyObject {
    func routeToDetails(with postId: String)
}

final class FeedRouter: BaseRouter {
    
}

// MARK: - PostFeedRouterProtocol

extension FeedRouter: FeedRouterProtocol {
    func routeToDetails(with postId: String) {
        let networkService = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)
        
        let detailsViewController = DetailsAssembly.build(with: networkService, and: postId)
        
        push(detailsViewController)
    }
}
