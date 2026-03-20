//
//  PostDetailsViewController.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import SnapKit
import UIKit

protocol PostDetailsViewControllerProtocol: AnyObject {
    func render(with viewState: PostDetailsViewState)
}

final class PostDetailsViewController: BaseViewController<PostDetailsPresenterProtocol> {
    
    // MARK: - UI Components
    
    private let detailsView: PostDetailsView = {
        let view = PostDetailsView()
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        presenter.perform(with: .onLoad)
    }
}

// MARK: - PostDetailsViewControllerProtocol

extension PostDetailsViewController: PostDetailsViewControllerProtocol {
    func render(with viewState: PostDetailsViewState) {
        switch viewState.kind {
        case .error(let message):
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.presenter.perform(with: .onErrorTapped)
            }
            alert.addAction(okAction)
            present(alert, animated: true)
            
        case .loaded(let itemViewState):
            detailsView.configure(with: itemViewState)
        }
    }
    
    func displayError(_ message: String, onOkTapped: @escaping () -> Void) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            onOkTapped()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - Private Methods

private extension PostDetailsViewController {
    
    // MARK: - Setup
    
    func setupUI() {
        view.addSubview(detailsView)
    }
    
    func setupLayout() {
        detailsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Constants

private extension PostDetailsViewController {
    enum Constant {
        static let mainColor = UIColor.systemIndigo
    }
}
