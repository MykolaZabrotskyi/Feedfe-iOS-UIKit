//
//  PostDetailsRouter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import UIKit

protocol PostDetailsRouterProtocol: AnyObject {
    func popToFeed()
}

final class PostDetailsRouter: BaseRouter {
    
}

// MARK: - PostDetailsRouterProtocol

extension PostDetailsRouter: PostDetailsRouterProtocol {
    func popToFeed() {
        pop()
    }
}
