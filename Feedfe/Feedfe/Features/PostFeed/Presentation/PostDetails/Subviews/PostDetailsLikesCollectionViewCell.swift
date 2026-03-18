//
//  PostDetailsLikesCountCollectionViewCell.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 12.03.2026.
//

import UIKit

final class PostDetailsLikesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let likesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.systemImage
        imageView.tintColor = Constant.color
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.font
        label.textColor = Constant.color
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constant.likesStackView
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Configuration
    
    func configure(likesCount: String) {
        likesLabel.text = likesCount
    }
}

// MARK: - Private Methods

private extension PostDetailsLikesCollectionViewCell {
    // MARK: - Setup
    
    func setupUI() {
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(likesImageView)
        stackView.addArrangedSubview(likesLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - Constants

private extension PostDetailsLikesCollectionViewCell {
    enum Constant {
        static let color = UIColor.systemIndigo
        static let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let likesStackView: CGFloat = 6.0
        static let systemImage = UIImage(
            systemName: "heart",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        )
    }
}

