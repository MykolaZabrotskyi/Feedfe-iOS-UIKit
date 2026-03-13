//
//  PostFeedListCollectionViewCell.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import UIKit

final class PostFeedListCollectionViewCell: UICollectionViewCell {
    
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
        label.font = Constant.Font.title
        label.textColor = Constant.mainColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.previewText
        label.textColor = UIColor.systemGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.systemImage
        imageView.tintColor = Constant.mainColor
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.likesLabel
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
        label.font = Constant.Font.dateFont
        label.textColor = UIColor.systemGray2
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Constant.Font.expandButton
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
    
    func configure(with viewState: PostFeedViewState) {
        dateLabel.text = viewState.date
        titleLabel.text = viewState.title
        previewLabel.text = viewState.previewText
        likesLabel.text = viewState.likesCount
        
        isExpanded = viewState.isExpanded
        haveExpandButton = isTextTruncated(text: viewState.previewText, font: previewLabel.font)
        expandButton.setTitle(viewState.expandButtonTitle, for: .normal)
        expandButton.isHidden = !haveExpandButton
    }
}

// MARK: - Private Methods

private extension PostFeedListCollectionViewCell {
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
}

// MARK: - Constants

private extension PostFeedListCollectionViewCell {
    enum Constant {
        static let mainColor = UIColor.systemIndigo
        static let cornerRadius: CGFloat = 6.0
        static let padding: CGFloat = 15.0
        
        static let systemImage = UIImage(
            systemName: "heart",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        )
        
        enum Font {
            static let title = UIFont.systemFont(ofSize: 21, weight: .bold)
            static let previewText = UIFont.systemFont(ofSize: 18, weight: .regular)
            static let likesLabel = UIFont.systemFont(ofSize: 18, weight: .semibold)
            static let dateFont = UIFont.systemFont(ofSize: 15, weight: .regular)
            static let expandButton = UIFont.systemFont(ofSize: 21, weight: .semibold)
        }
        
        enum Spacing {
            static let likesStackView: CGFloat = 3.0
            static let verticalStackView: CGFloat = 9.0
            static let cellStackView: CGFloat = 15.0
        }
    }
}
