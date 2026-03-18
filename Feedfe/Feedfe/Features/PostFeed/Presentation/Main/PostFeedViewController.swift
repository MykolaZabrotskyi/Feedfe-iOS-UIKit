//
//  PostFeedViewController.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import UIKit
import CustomTab

enum CustomTabSelectedMode: Int, CaseIterable {
    case list
    case grid
    case gallery
}

protocol PostFeedViewControllerProtocol: AnyObject {
    func render(with viewState: PostFeedViewState)
    func displayError(_ message: String)
}

final class PostFeedViewController: BaseViewController<PostFeedPresenterProtocol> {
    
    // MARK: - Properties
    
    typealias DataSource = UICollectionViewDiffableDataSource<PostFeedViewState.SectionType, PostFeedViewState.SectionItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PostFeedViewState.SectionType, PostFeedViewState.SectionItem>
    private lazy var dataSource: DataSource = setupDataSource()
    
    // MARK: - UI Components
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = Constant.SearchBar.placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = Constant.Color.main
        if let customClearIcon = Constant.SearchBar.clearIcon {
            let templateImage = customClearIcon.withRenderingMode(.alwaysTemplate)
            searchBar.setImage(templateImage, for: .clear, state: .normal)
        }
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.register(cell: PostFeedCollectionViewCell.self)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - CustomTabViewDelegate

extension PostFeedViewController: CustomTabViewDelegate {
    func customTabView(_ view: CustomTabView, didSelectTabAt index: Int) {
        guard let mode = CustomTabSelectedMode(rawValue: index) else {
            return
        }
        presenter.didChangeDisplayMode(to: mode)
    }
}

// MARK: - UICollectionViewDelegate

extension PostFeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter.didSelectPost(at: indexPath.item)
    }
}

// MARK: - UISearchBarDelegate

extension PostFeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.search(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - PostFeedViewControllerProtocol

extension PostFeedViewController: PostFeedViewControllerProtocol {
    func render(with viewState: PostFeedViewState) {
        if let firstSection = viewState.sections.first {
            collectionView.isScrollEnabled = (firstSection.type != .gallery)
        }
        
        var snapshot = Snapshot()
        for section in viewState.sections {
            snapshot.appendSections([section.type])
            snapshot.appendItems(section.items, toSection: section.type)
        }
        
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
    func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self else {
                return nil
            }
            
            let sectionType = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            
            switch sectionType {
            case .list:
                return self.makeListSection()
                
            case .grid:
                return self.makeGridSection()
                
            case .gallery:
                return self.makeGallerySection()
            }
        }
    }
    
    func makeListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        return makeSection(group: group)
    }
    
    func makeGridSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(Constant.Spacing.collectionView)
        return makeSection(group: group)
    }
    
    func makeGallerySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.95))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return makeSection(group: group, orthogonalScrollingBehavior: .groupPagingCentered)
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
        mainVerticalStackView.addArrangedSubview(searchBar)
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
            collectionView, indexPath, sectionItem
        ) -> UICollectionViewCell? in
            guard let self else {
                return nil
            }
            
            let cell: PostFeedCollectionViewCell = collectionView.dequeue(for: indexPath)
            let sectionType = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            cell.configure(with: sectionItem, sectionType: sectionType)
            
            cell.onExpandTapped = { [weak self] in
                self?.presenter.toggleExpand(at: sectionItem.id)
            }
            
            return cell
        }
        return dataSource
    }
}

// MARK: - Constants

private extension PostFeedViewController {
    enum Constant {
        enum SearchBar {
            static let placeholder = "Search"
            static let clearIcon = UIImage(systemName: "xmark.circle.fill")
            static let height: CGFloat = 50.0
        }
        
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
