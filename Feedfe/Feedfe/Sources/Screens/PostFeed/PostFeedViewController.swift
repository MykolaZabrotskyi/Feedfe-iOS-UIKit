//
//  PostFeedViewController.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import UIKit

class PostFeedViewController: UIViewController {
    
    // MARK: - Properties
    
    private var posts: [PostFeedModel] = []
    
    // MARK: - UI Components
    
    private let postFeedTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(cell: PostFeedTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let networkService: NetworkServiceProtocol = NetworkService()
        let postFeedAPIService: PostFeedAPIServiceProtocol = PostFeedAPIService(networkService: networkService)
        postFeedAPIService.fetchPosts { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case .success(let posts):
                debugPrint(String(posts.count))
                dump(posts)
                self.posts = posts
                self.postFeedTableView.reloadData()
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
        
        setupPostFeedTableView()
        setupLayout()
    }
    
    // MARK: - Setup
    
    func setupLayout() {
        view.addSubview(postFeedTableView)
        
        NSLayoutConstraint.activate([
            postFeedTableView.topAnchor.constraint(equalTo: view.topAnchor),
            postFeedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            postFeedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postFeedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
    }
    
    func setupPostFeedTableView() {

        postFeedTableView.dataSource = self
    }
}

extension PostFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostFeedTableViewCell = postFeedTableView.dequeue(for: indexPath)
        
        cell.configure(with: posts[indexPath.row])
        
        return cell
    }
}
