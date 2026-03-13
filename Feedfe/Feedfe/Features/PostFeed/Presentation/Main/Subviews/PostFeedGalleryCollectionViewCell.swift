//
//  PostFeedGalleryCollectionViewCell.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 13.03.2026.
//

import UIKit

final class PostFeedGalleryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.mainColor.withAlphaComponent(0.05)
        view.layer.cornerRadius = Constant.cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Constant.mainColor.withAlphaComponent(0.2)
        imageView.contentMode = .center
        imageView.image = Constant.systemImage
        imageView.tintColor = Constant.mainColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.title
        label.textColor = Constant.mainColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.previewText
        label.textColor = .systemGray
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.infoText
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Configuration
    
    func configure(with viewState: PostFeedViewState) {
        titleLabel.text = viewState.title
        previewLabel.text = viewState.previewText
        infoLabel.text = "\(viewState.likesCount) \(viewState.date)"
    }
}

// MARK: - Private Methods

private extension PostFeedGalleryCollectionViewCell {
    func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(previewLabel)
        containerView.addSubview(infoLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 180),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            previewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            previewLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            previewLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            infoLabel.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: 12),
            infoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            infoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            infoLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12)
        ])
    }
}

// MARK: - Constants

private extension PostFeedGalleryCollectionViewCell {
    enum Constant {
        static let mainColor = UIColor.systemIndigo
        static let cornerRadius: CGFloat = 12.0
        static let systemImage = UIImage(systemName: "photo.fill")
        
        enum Font {
            static let title = UIFont.systemFont(ofSize: 20, weight: .bold)
            static let previewText = UIFont.systemFont(ofSize: 16, weight: .regular)
            static let infoText = UIFont.systemFont(ofSize: 14, weight: .medium)
        }
    }
}
