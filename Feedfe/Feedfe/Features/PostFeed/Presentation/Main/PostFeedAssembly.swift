//
//  PostFeedAssembly.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import UIKit

final class PostFeedAssembly {
    static func build() -> UIViewController {
        let viewController = PostFeedViewController()
        let router = PostFeedRouter(viewController: viewController)
        
        let networkService = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)
        let dateFormatter = DIContainer.shared.resolve(type: DateFormatterProtocol.self)
        let postAPIService = PostAPIService(networkService: networkService)
        let viewStateFactory = PostFeedViewStateFactory(dateFormatter: dateFormatter)
        let presenter = PostFeedPresenter(
            viewController: viewController,
            router: router,
            postAPIService: postAPIService,
            viewStateFactory: viewStateFactory
        )
        
        viewController.inject(presenter: presenter)
        return viewController
    }
}
