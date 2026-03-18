//
//  PostFeedCollectionViewCell.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import UIKit

nonisolated struct PostFeedItemViewState: Hashable {
    let id: String
    let date: String
    let title: String
    let previewText: String
    let likesCount: String
    var expandButtonTitle: String
    var isExpanded: Bool
}

final class PostFeedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var haveExpandButton: Bool = false {
        didSet {
            expandButton.isHidden = !haveExpandButton
        }
    }
    
    private var isExpanded: Bool = false {
        didSet {
            previewLabel.numberOfLines = isExpanded ? 0 : 2
        }
    }
    
    var onExpandTapped: (() -> Void)?
    private var currentMode: CustomTabSelectedMode = .list
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.mainColor.withAlphaComponent(0.1)
        view.layer.cornerRadius = Constant.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constant.mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Constant.mainColor
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constant.mainColor
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constant.Spacing.likesStackView
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray2
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Constant.List.Font.expandButton
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constant.mainColor
        button.layer.cornerRadius = Constant.cornerRadius
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constant.Spacing.verticalStackView
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constant.Spacing.cellStackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    func toggleExpand(expandButtonTitle: String) {
        self.isExpanded.toggle()
        self.expandButton.setTitle(expandButtonTitle, for: .normal)
    }
    
    // MARK: - Configuration
    
    func configure(with itemViewState: PostFeedItemViewState, and mode: CustomTabSelectedMode) {
        dateLabel.text = itemViewState.date
        titleLabel.text = itemViewState.title
        previewLabel.text = itemViewState.previewText
        likesLabel.text = itemViewState.likesCount
        
        applyStyle(for: mode)
        
        if mode == .list {
            isExpanded = itemViewState.isExpanded
            let haveExpandButton = isTextTruncated(text: itemViewState.previewText, font: previewLabel.font)
            expandButton.setTitle(itemViewState.expandButtonTitle, for: .normal)
            expandButton.isHidden = !haveExpandButton
        } else {
            expandButton.isHidden = true
        }
    }
}

// MARK: - Private Methods

private extension PostFeedCollectionViewCell {
    @objc
    func expandButtonTapped() {
        onExpandTapped?()
    }
    
    func isTextTruncated(
        text: String,
        font: UIFont,
        maxLines: Int = 2,
        paddingCount: Int = 4
    ) -> Bool {
        let availableWidth = self.bounds.width - CGFloat(paddingCount) * Constant.padding
        let maxSize = CGSize(width: availableWidth, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let attributes = [NSAttributedString.Key.font: font]
        
        let textRect = text.boundingRect(
            with: maxSize,
            options: options,
            attributes: attributes,
            context: nil
        )
        
        return textRect.height > (font.lineHeight * CGFloat(maxLines))
    }
    
    // MARK: - Setup
    
    func setupUI(){
        contentView.addSubview(containerView)
        containerView.addSubview(cellStackView)
        
        likesStackView.addArrangedSubview(likesImageView)
        likesStackView.addArrangedSubview(likesLabel)
        
        horizontalStackView.addArrangedSubview(likesStackView)
        horizontalStackView.addArrangedSubview(dateLabel)
        
        verticalStackView.addArrangedSubview(previewLabel)
        verticalStackView.addArrangedSubview(expandButton)
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(verticalStackView)
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        previewLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        previewLabel.setContentHuggingPriority(.required, for: .vertical)
        
        expandButton.setContentHuggingPriority(.required, for: .vertical)
        expandButton.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            cellStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constant.padding),
            cellStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constant.padding),
            cellStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constant.padding),
            cellStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constant.padding),
        ])
    }
    
    private func applyStyle(for mode: CustomTabSelectedMode) {
        switch mode {
        case .list:
            titleLabel.font = Constant.List.Font.title
            titleLabel.numberOfLines = 0
            
            previewLabel.font = Constant.List.Font.previewText
            previewLabel.numberOfLines = 2
            
            likesImageView.image = Constant.List.systemImage
            likesLabel.font = Constant.List.Font.likes
            dateLabel.font = Constant.List.Font.date
            
        case .grid:
            titleLabel.font = Constant.Grid.Font.title
            titleLabel.numberOfLines = 1
            
            previewLabel.font = Constant.Grid.Font.previewText
            previewLabel.numberOfLines = 2
            
            likesImageView.image = Constant.Grid.systemImage
            likesLabel.font = Constant.Grid.Font.likes
            dateLabel.font = Constant.Grid.Font.date
            
        case .gallery:
            titleLabel.font = Constant.Gallery.Font.title
            titleLabel.numberOfLines = 0
            
            previewLabel.font = Constant.Gallery.Font.previewText
            previewLabel.numberOfLines = 0
            
            likesImageView.image = Constant.Gallery.systemImage
            likesLabel.font = Constant.Gallery.Font.likes
            dateLabel.font = Constant.Gallery.Font.date
        }
    }
}

// MARK: - Constants

private extension PostFeedCollectionViewCell {
    enum Constant {
        static let mainColor = UIColor.systemIndigo
        static let cornerRadius: CGFloat = 6.0
        static let padding: CGFloat = 15.0
        
        enum List {
            static let systemImage = UIImage(
                systemName: "heart",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
            )
            
            enum Font {
                static let title = UIFont.systemFont(ofSize: 21, weight: .bold)
                static let previewText = UIFont.systemFont(ofSize: 18, weight: .regular)
                static let likes = UIFont.systemFont(ofSize: 18, weight: .semibold)
                static let date = UIFont.systemFont(ofSize: 15, weight: .regular)
                static let expandButton = UIFont.systemFont(ofSize: 21, weight: .semibold)
            }
        }
        
        enum Grid {
            static let systemImage = UIImage(
                systemName: "heart",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
            )
            
            enum Font {
                static let title = UIFont.systemFont(ofSize: 18, weight: .bold)
                static let previewText = UIFont.systemFont(ofSize: 15, weight: .regular)
                static let likes = UIFont.systemFont(ofSize: 15, weight: .semibold)
                static let date = UIFont.systemFont(ofSize: 12, weight: .regular)
            }
        }
        
        enum Gallery {
            static let systemImage = UIImage(
                systemName: "heart",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 21, weight: .semibold)
            )
            
            enum Font {
                static let title = UIFont.systemFont(ofSize: 24, weight: .bold)
                static let previewText = UIFont.systemFont(ofSize: 21, weight: .regular)
                static let likes = UIFont.systemFont(ofSize: 21, weight: .semibold)
                static let date = UIFont.systemFont(ofSize: 18, weight: .regular)
            }
        }
        
        enum Spacing {
            static let likesStackView: CGFloat = 3.0
            static let verticalStackView: CGFloat = 9.0
            static let cellStackView: CGFloat = 15.0
        }
    }
}
