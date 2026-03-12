//
//  FeedAssembly.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import UIKit

final class FeedAssembly {
    static func build() -> UIViewController {
        let viewController = FeedViewController()
        let router = FeedRouter(viewController: viewController)
        
        let networkService = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)
        let dateFormatter = DIContainer.shared.resolve(type: DateFormatterProtocol.self)
        
        let feedAPIService = FeedAPIService(networkService: networkService)
        
        let presenter = FeedPresenter(
            viewController: viewController,
            router: router,
            feedAPIService: feedAPIService,
            dateFormatter: dateFormatter
        )
        
        viewController.inject(presenter: presenter)
        
        return viewController
    }
}
