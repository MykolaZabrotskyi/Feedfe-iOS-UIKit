//
//  PostFeedAssembly.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import UIKit

final class PostFeedAssembly {
    static func build(networkService: NetworkServiceProtocol) -> UIViewController {
        let viewController = PostFeedViewController()
        let router = PostFeedRouter(viewController: viewController)
        let networkAPIService = PostFeedAPIService(networkService: networkService)
        let presenter = PostFeedPresenter(viewController: viewController, router: router, networkAPIService: networkAPIService)
        
        viewController.inject(presenter: presenter)
        
        return viewController
    }
}
