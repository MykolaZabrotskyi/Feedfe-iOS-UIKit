//
//  FeedViewController.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import UIKit

protocol FeedViewControllerProtocol: AnyObject {
    func displayPosts()
    func displayError(_ message: String)
    func updateRow(at index: Int, with expandButtonTitle: String)
}

class FeedViewController: BaseViewController<FeedPresenterProtocol> {
    
    // MARK: - UI Components
    
    private let feedTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(cell: FeedTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constant.estimatedRowHeight
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
        view.addSubview(feedTableView)
        
        NSLayoutConstraint.activate([
            feedTableView.topAnchor.constraint(equalTo: view.topAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            feedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
    }
    
    func setupPostFeedTableView() {
        feedTableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.postsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedTableViewCell = feedTableView.dequeue(for: indexPath)
        
        cell.configure(with: presenter.getPost(at: indexPath.row))
        
        cell.onExpandTapped = { [weak self] in
            self?.presenter.toggleExpand(at: indexPath.row)
        }
        
        return cell
    }
}

// MARK: - PostFeedViewControllerProtocol

extension FeedViewController: FeedViewControllerProtocol {
    func displayPosts() {
        feedTableView.reloadData()
    }
    
    func displayError(_ message: String) {
        debugPrint(message)
    }
    
    func updateRow(at index: Int, with expandButtonTitle: String) {
        let indexPath = IndexPath(row: index, section: 0)
        
        if let cell = feedTableView.cellForRow(at: indexPath) as? FeedTableViewCell {
            feedTableView.performBatchUpdates({
                cell.toggleExpand(expandButtonTitle: expandButtonTitle)
                cell.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

// MARK: - Constants

private extension FeedViewController {
    enum Constant {
        static let estimatedRowHeight: CGFloat = 200.0
    }
}
