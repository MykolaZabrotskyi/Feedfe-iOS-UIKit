//
//  PostDetailsViewController.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import UIKit

enum PostDetailsCellType: Int, CaseIterable {
    case image
    case title
    case text
    case likes
    case date
}

protocol PostDetailsViewControllerProtocol: AnyObject {
    func displayDetails(with viewState: PostDetailsViewState)
    func displayError(_ message: String, onOkTapped: @escaping () -> Void)
}

final class PostDetailsViewController: BaseViewController<PostDetailsPresenterProtocol> {
    
    // MARK: - Properties
    
    private var viewState: PostDetailsViewState?
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        collectionView.backgroundColor = Constant.mainColor.withAlphaComponent(0.1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        
        collectionView.register(cell: PostDetailsImageCollectionViewCell.self)
        collectionView.register(cell: PostDetailsTitleCollectionViewCell.self)
        collectionView.register(cell: PostDetailsTextCollectionViewCell.self)
        collectionView.register(cell: PostDetailsLikesCollectionViewCell.self)
        collectionView.register(cell: PostDetailsDateCollectionViewCell.self)
        
        return collectionView
    }()
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        
        presenter.fetchPostDetails()
    }
}

// MARK: - PostDetailsViewControllerProtocol

extension PostDetailsViewController: PostDetailsViewControllerProtocol {
    func displayDetails(with viewState: PostDetailsViewState) {
        self.viewState = viewState
        self.collectionView.reloadData()
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

// MARK: - UICollectionViewDataSource

extension PostDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewState == nil ? 0 : PostDetailsCellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewState, let cellType = PostDetailsCellType(rawValue: indexPath.item) else {
            return UICollectionViewCell()
        }
        
        switch cellType {
        case .image:
            let cell: PostDetailsImageCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: viewState.image)
            return cell
            
        case .title:
            let cell: PostDetailsTitleCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: viewState.title)
            return cell
            
        case .text:
            let cell: PostDetailsTextCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: viewState.text)
            return cell
            
        case .likes:
            let cell: PostDetailsLikesCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(likesCount: viewState.likesCount)
            return cell
            
        case .date:
            let cell: PostDetailsDateCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(date: viewState.date)
            return cell
        }
    }
}

// MARK: - Private Methods

private extension PostDetailsViewController {
    
    // MARK: - Setup
    
    func setupUI() {
        view.addSubview(collectionView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func createLayout() -> UICollectionViewLayout {
        let fullWidthItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1.0))
        let fullWidthItem = NSCollectionLayoutItem(layoutSize: fullWidthItemSize)
        
        let halfWidthItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(1.0))
        let halfWidthItem = NSCollectionLayoutItem(layoutSize: halfWidthItemSize)
        
        let bottomGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let bottomGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: bottomGroupSize,
            subitems: [halfWidthItem, halfWidthItem]
        )
        
        let mainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1.0))
        let mainGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: mainGroupSize,
            subitems: [
                fullWidthItem,
                fullWidthItem,
                fullWidthItem,
                bottomGroup
            ]
        )
        
        mainGroup.interItemSpacing = .fixed(Constant.spacing)
        
        let section = NSCollectionLayoutSection(group: mainGroup)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constant.spacing,
            leading: Constant.spacing,
            bottom: Constant.spacing,
            trailing: Constant.spacing
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Constants

private extension PostDetailsViewController {
    enum Constant {
        static let mainColor = UIColor.systemIndigo
        static let spacing: CGFloat = 12.0
    }
}
