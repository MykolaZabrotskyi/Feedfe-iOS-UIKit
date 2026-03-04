//
//  PostFeedViewController.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import UIKit

class PostFeedViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let networkService: NetworkServiceProtocol = NetworkService()
        let postFeedAPIService: PostFeedAPIServiceProtocol = PostFeedAPIService(networkService: networkService)
        postFeedAPIService.fetchPosts { result in
            switch result {
            case .success(let posts):
                debugPrint(String(posts.count))
                dump(posts)
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
