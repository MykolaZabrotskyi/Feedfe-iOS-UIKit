//
//  PostFeedViewController.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import UIKit

protocol PostFeedViewControllerProtocol: AnyObject {
    func displayPosts()
    func displayError(_ message: String)
}

class PostFeedViewController: BaseViewController<PostFeedPresenterProtocol> {
    
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
        
        presenter.fetchPostFeed()
        
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
        return presenter.postsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostFeedTableViewCell = postFeedTableView.dequeue(for: indexPath)
        
        cell.configure(with: presenter.getPost(at: indexPath.row))
        
        return cell
    }
}

extension PostFeedViewController: PostFeedViewControllerProtocol {
    func displayPosts() {
        postFeedTableView.reloadData()
    }
    
    func displayError(_ message: String) {
        debugPrint(message)
    }
}
