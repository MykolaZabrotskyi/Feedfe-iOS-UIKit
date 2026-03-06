//
//  PostFeedRouter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import UIKit

protocol PostFeedRouterProtocol: AnyObject {
    
}

final class PostFeedRouter {
    
    // MARK: - Properties
    
    private weak var viewController: UIViewController?
    
    // MARK: - Init
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - PostFeedRouterProtocol

extension PostFeedRouter: PostFeedRouterProtocol {
    
}
