//
//  PostFeedViewController.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import UIKit
import CustomTab

enum PostFeedCellType: Int, CaseIterable {
    case list
    case grid
    case gallery
}

enum Section {
  case main
}

typealias DataSource = UICollectionViewDiffableDataSource<Section, PostFeedViewState>

protocol PostFeedViewControllerProtocol: AnyObject {
    func displayPosts()
    func displayError(_ message: String)
    func updateRow(at index: Int, with expandButtonTitle: String)
}

class PostFeedViewController: BaseViewController<PostFeedPresenterProtocol> {
    
    private var currentDisplayMode: PostFeedCellType = .list
    
    // MARK: - UI Components
    
    private lazy var tabView: CustomTabView = {
        let view = CustomTabView(
            tabTitles: ["List", "Grid", "Gallery"],
            mainColor: Constant.Color.main,
            secondColor: Constant.Color.second
        )
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createListLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.register(cell: PostFeedListCollectionViewCell.self)
        collectionView.register(cell: PostFeedGridCollectionViewCell.self)
        collectionView.register(cell: PostFeedGalleryCollectionViewCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var mainVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constant.Spacing.mainVerticalStackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.fetchPostFeed()
        
        setupCollectionView()
        setupUI()
        setupLayout()
    }
}

// MARK: - CustomTabViewDelegate

extension PostFeedViewController: CustomTabViewDelegate {
    func customTabView(_ view: CustomTabView, didSelectTabAt index: Int) {
        guard let mode = PostFeedCellType(rawValue: index) else {
            return
        }
        currentDisplayMode = mode
        
        let layout: UICollectionViewLayout
        
        switch mode {
        case .list:
            layout = createListLayout()
            collectionView.isScrollEnabled = true
        case .grid:
            layout = createGridLayout()
            collectionView.isScrollEnabled = true
        case .gallery:
            layout = createGalleryLayout()
            collectionView.isScrollEnabled = false
        }
        
        UIView.performWithoutAnimation {
            self.collectionView.setCollectionViewLayout(layout, animated: false)
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension PostFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.postsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = presenter.getPost(at: indexPath.item)
        
        switch currentDisplayMode {
        case .list:
            let cell: PostFeedListCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: model)
            cell.onExpandTapped = { [weak self] in
                self?.presenter.toggleExpand(at: indexPath.item)
            }
            return cell
            
        case .grid:
            let cell: PostFeedGridCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: model)
            return cell
            
        case .gallery:
            let cell: PostFeedGalleryCollectionViewCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: model)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension PostFeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter.didSelectPost(at: indexPath.item)
    }
}

// MARK: - PostFeedViewControllerProtocol

extension PostFeedViewController: PostFeedViewControllerProtocol {
    func displayPosts() {
        collectionView.reloadData()
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateRow(at index: Int, with expandButtonTitle: String) {
        let indexPath = IndexPath(item: index, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? PostFeedListCollectionViewCell {
            collectionView.performBatchUpdates({
                cell.toggleExpand(expandButtonTitle: expandButtonTitle)
                cell.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

// MARK: - Private Methods

private extension PostFeedViewController {
    
    func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constant.Spacing.collectionView
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constant.Spacing.collectionView,
            leading: Constant.Spacing.collectionView,
            bottom: Constant.Spacing.collectionView,
            trailing: Constant.Spacing.collectionView
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(Constant.Spacing.collectionView)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constant.Spacing.collectionView
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constant.Spacing.collectionView,
            leading: Constant.Spacing.collectionView,
            bottom: Constant.Spacing.collectionView,
            trailing: Constant.Spacing.collectionView)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createGalleryLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .fractionalHeight(0.95)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = Constant.Spacing.collectionView
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constant.Spacing.collectionView,
            leading: Constant.Spacing.collectionView,
            bottom: Constant.Spacing.collectionView,
            trailing: Constant.Spacing.collectionView
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Setup
    
    func setupUI() {
        view.addSubview(mainVerticalStackView)
        mainVerticalStackView.addArrangedSubview(tabView)
        mainVerticalStackView.addArrangedSubview(collectionView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            tabView.heightAnchor.constraint(equalToConstant: Constant.customTabViewHeight),
            mainVerticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - Constants

private extension PostFeedViewController {
    enum Constant {
        static let customTabViewHeight: CGFloat = 50.0
        
        enum Color {
            static let main = UIColor.systemIndigo
            static let second = UIColor.systemGray
        }
        
        enum Spacing {
            static let mainVerticalStackView: CGFloat = 9.0
            static let collectionView: CGFloat = 12.0
        }
    }
}
