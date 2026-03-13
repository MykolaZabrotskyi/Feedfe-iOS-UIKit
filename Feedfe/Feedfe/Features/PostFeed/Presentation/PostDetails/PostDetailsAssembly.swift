//
//  PostDetailsAssembly.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import UIKit

final class PostDetailsAssembly {
    static func build(with postID: String) -> UIViewController {
        let viewController = PostDetailsViewController()
        let router = PostDetailsRouter(viewController: viewController)
        
        let networkService = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)
        let dateFormatter = DIContainer.shared.resolve(type: DateFormatterProtocol.self)
        let postAPIService = PostAPIService(networkService: networkService)
        let presenter = PostDetailsPresenter(
            viewController: viewController,
            router: router,
            postID: postID,
            dateFormatter: dateFormatter,
            postAPIService: postAPIService
        )
        
        viewController.inject(presenter: presenter)
        return viewController
    }
}
