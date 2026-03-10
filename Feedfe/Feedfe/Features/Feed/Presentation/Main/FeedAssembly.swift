//
//  FeedAssembly.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import UIKit

final class FeedAssembly {
    static func build(with networkService: NetworkServiceProtocol) -> UIViewController {
        let viewController = FeedViewController()
        let router = FeedRouter(viewController: viewController)
        let networkAPIService = FeedAPIService(networkService: networkService)
        let presenter = FeedPresenter(
            viewController: viewController,
            router: router,
            networkAPIService: networkAPIService
        )
        
        viewController.inject(presenter: presenter)
        
        return viewController
    }
}
