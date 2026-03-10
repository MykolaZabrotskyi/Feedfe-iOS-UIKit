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

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.didSelectPost(at: indexPath.row)
    }
}

// MARK: - PostFeedViewControllerProtocol

extension FeedViewController: FeedViewControllerProtocol {
    func displayPosts() {
        feedTableView.reloadData()
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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

// MARK: - Private Methods

private extension FeedViewController {
    
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
        feedTableView.delegate = self
    }
}

// MARK: - Constants

private extension FeedViewController {
    enum Constant {
        static let estimatedRowHeight: CGFloat = 200.0
    }
}
