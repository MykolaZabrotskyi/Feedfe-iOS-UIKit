//
//  DetailsAssembly.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import UIKit

final class DetailsAssembly {
    static func build(with networkService: NetworkServiceProtocol, and postId: String) -> UIViewController {
        let viewController = DetailsViewController()
        let router = DetailsRouter(viewController: viewController)
        let networkAPIService = DetailsAPIService(networkService: networkService)
        let presenter = DetailsPresenter(
            viewController: viewController,
            router: router,
            networkAPIService: networkAPIService,
            postId: postId
        )
        
        viewController.inject(presenter: presenter)
        
        return viewController
    }
}
