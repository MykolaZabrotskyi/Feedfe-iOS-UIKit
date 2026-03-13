//
//  PostFeedGridCollevtionViewCell.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 13.03.2026.
//

import UIKit

final class PostFeedGridCollevtionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.mainColor.withAlphaComponent(0.1)
        view.layer.cornerRadius = Constant.cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray4
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = Constant.systemImage
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.title
        label.textColor = Constant.mainColor
        label.numberOfLines = 2
        label.textAlignment = .center
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
    
    func configure(with model: PostFeedViewState) {
        titleLabel.text = model.title
    }
}

// MARK: - Private Methods

private extension PostFeedGridCollevtionViewCell {
    func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
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
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.7),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -4)
        ])
    }
}

// MARK: - Constants

private extension PostFeedGridCollevtionViewCell {
    enum Constant {
        static let mainColor = UIColor.systemIndigo
        static let cornerRadius: CGFloat = 8.0
        static let systemImage = UIImage(systemName: "photo")
        
        enum Font {
            static let title = UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
    }
}
