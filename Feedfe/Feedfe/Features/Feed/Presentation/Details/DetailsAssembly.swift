//
//  DetailsAssembly.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import UIKit

final class DetailsAssembly {
    static func build(with postId: String) -> UIViewController {
        let viewController = DetailsViewController()
        let router = DetailsRouter(viewController: viewController)
        
        let networkService = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)
        let dateFormatter = DIContainer.shared.resolve(type: DateFormatterProtocol.self)
        
        let feedAPIService = FeedAPIService(networkService: networkService)
        
        let presenter = DetailsPresenter(
            viewController: viewController,
            router: router,
            postId: postId,
            dateFormatter: dateFormatter,
            feedAPIService: feedAPIService
        )
        
        viewController.inject(presenter: presenter)
        
        return viewController
    }
}
