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

protocol PostFeedViewControllerProtocol: AnyObject {
    func displayPosts(with posts: [PostFeedViewState])
    func displayError(_ message: String)
}

class PostFeedViewController: BaseViewController<PostFeedPresenterProtocol> {
    
    nonisolated enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PostFeedViewState>
    
    private lazy var dataSource: DataSource = setupDataSource()
    private var currentDisplayMode: PostFeedCellType = .list
    
    // MARK: - UI Components
    
    private lazy var tabView: CustomTabView = {
        let view = CustomTabView(
            tabTitles: Constant.CustomTab.titles,
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
        
        setupCollectionView()
        setupUI()
        setupLayout()
        
        presenter.fetchPostFeed()
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
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        var snapshot = dataSource.snapshot()
        if !snapshot.itemIdentifiers.isEmpty {
            snapshot.reloadSections([.main])
            dataSource.apply(snapshot, animatingDifferences: true)
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
    func displayPosts(with posts: [PostFeedViewState]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PostFeedViewState>()
        snapshot.appendSections([.main])
        snapshot.appendItems(posts, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
        
        let section = makeSection(group: group)
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
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item, count: 2
        )
        group.interItemSpacing = .fixed(Constant.Spacing.collectionView)
        
        let section = makeSection(group: group)
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
        
        let section = makeSection(group: group, orthogonalScrollingBehavior: .groupPagingCentered)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func makeSection(
        group: NSCollectionLayoutGroup,
        orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior? = nil
    ) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = Constant.Spacing.collectionView
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constant.Spacing.collectionView,
            leading: Constant.Spacing.collectionView,
            bottom: Constant.Spacing.collectionView,
            trailing: Constant.Spacing.collectionView
        )
        
        if let behavior = orthogonalScrollingBehavior {
            section.orthogonalScrollingBehavior = behavior
        }
        
        return section
    }
    
    // MARK: - Setup
    
    func setupUI() {
        view.addSubview(mainVerticalStackView)
        mainVerticalStackView.addArrangedSubview(tabView)
        mainVerticalStackView.addArrangedSubview(collectionView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            tabView.heightAnchor.constraint(equalToConstant: Constant.CustomTab.height),
            mainVerticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
    }
    
    func setupDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] (
            collectionView, indexPath, viewState
        ) -> UICollectionViewCell? in
            guard let self = self else {
                return nil
            }
            
            switch self.currentDisplayMode {
            case .list:
                let cell: PostFeedListCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.configure(with: viewState)
                cell.onExpandTapped = { [weak self] in
                    self?.presenter.toggleExpand(at: indexPath.item)
                }
                return cell
                
            case .grid:
                let cell: PostFeedGridCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.configure(with: viewState)
                return cell
                
            case .gallery:
                let cell: PostFeedGalleryCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.configure(with: viewState)
                return cell
            }
        }
        return dataSource
    }
}

// MARK: - Constants

private extension PostFeedViewController {
    enum Constant {
        enum CustomTab {
            static let titles = ["List", "Grid", "Gallery"]
            static let height: CGFloat = 50.0
        }
        
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
