//
//  DetailsViewController.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import UIKit

protocol DetailsViewControllerProtocol: AnyObject {
    func displayDetails(with state: PostDetailViewState)
    func displayError(_ message: String)
}

final class DetailsViewController: BaseViewController<DetailsPresenterProtocol> {
    
    // MARK: - Properties
    
    private var viewState: PostDetailViewState?
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        collectionView.backgroundColor = Constant.mainColor.withAlphaComponent(0.1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        
        collectionView.register(cell: PostImageCell.self)
        collectionView.register(cell: PostTitleCell.self)
        collectionView.register(cell: PostDescriptionCell.self)
        collectionView.register(cell: PostLikesCell.self)
        collectionView.register(cell: PostDateCell.self)
        
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

// MARK: - DetailsViewControllerProtocol

extension DetailsViewController: DetailsViewControllerProtocol {
    func displayDetails(with state: PostDetailViewState) {
        self.viewState = state
        self.collectionView.reloadData()
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewState == nil ? 0 : PostDetailCells.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let state = viewState, let cellType = PostDetailCells(rawValue: indexPath.item) else {
            return UICollectionViewCell()
        }
        
        switch cellType {
        case .image:
            let cell: PostImageCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: state.postImage)
            return cell
            
        case .title:
            let cell: PostTitleCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: state.title)
            return cell
            
        case .description:
            let cell: PostDescriptionCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: state.text)
            return cell
            
        case .likes:
            let cell: PostLikesCell = collectionView.dequeue(for: indexPath)
            cell.configure(likes: state.likesCount)
            return cell
            
        case .date:
            let cell: PostDateCell = collectionView.dequeue(for: indexPath)
            cell.configure(date: state.timestamp)
            return cell
        }
    }
}

// MARK: - Private Methods

private extension DetailsViewController {
    
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
        let fullWidthItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let fullWidthItem = NSCollectionLayoutItem(layoutSize: fullWidthItemSize)
        
        let halfWidthItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(1.0)
        )
        let halfWidthItem = NSCollectionLayoutItem(layoutSize: halfWidthItemSize)
        
        let bottomGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let bottomGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: bottomGroupSize,
            subitems: [halfWidthItem, halfWidthItem]
        )
        
        let mainGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let mainGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: mainGroupSize,
            subitems: [fullWidthItem, fullWidthItem, fullWidthItem, bottomGroup]
        )
        
        mainGroup.interItemSpacing = .fixed(Constant.spacing)
        
        let section = NSCollectionLayoutSection(group: mainGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: Constant.spacing, leading: Constant.spacing, bottom: Constant.spacing, trailing: Constant.spacing)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Constants

private extension DetailsViewController {
    enum Constant {
        static let mainColor = UIColor.systemIndigo
        static let spacing: CGFloat = 15.0
    }
}
