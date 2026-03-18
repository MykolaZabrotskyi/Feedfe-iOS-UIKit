//
//  PostFeedRouter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import UIKit

protocol PostFeedRouterProtocol: AnyObject {
    func routeToDetails(with postId: String)
}

final class PostFeedRouter: BaseRouter {
    
}

// MARK: - PostFeedRouterProtocol

extension PostFeedRouter: PostFeedRouterProtocol {
    func routeToDetails(with postId: String) {
        let detailsViewController = PostDetailsAssembly.build(with: postId)
        push(detailsViewController)
    }
}
