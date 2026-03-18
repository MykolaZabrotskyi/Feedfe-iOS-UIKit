//
//  PostDetailsImageCollectionViewCell.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 12.03.2026.
//

import UIKit
import Kingfisher

final class PostDetailsImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.cornerRadius
        imageView.layer.borderWidth = Constant.borderWidth
        imageView.layer.borderColor = Constant.color.cgColor
        imageView.backgroundColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Configuration
    
    func configure(with url: URL?) {
        postImageView.kf.indicatorType = .activity
        postImageView.kf.setImage(with: url, placeholder: nil)
    }
}

// MARK: - Private Methods

private extension PostDetailsImageCollectionViewCell {
    
    // MARK: - Setup
    
    func setupUI() {
        contentView.addSubview(postImageView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: Constant.postImageHeight)
        ])
    }
}

// MARK: - Constants

private extension PostDetailsImageCollectionViewCell {
    enum Constant {
        static let color = UIColor.systemIndigo
        static let cornerRadius: CGFloat = 6.0
        static let postImageHeight: CGFloat = 250.0
        static let borderWidth: CGFloat = 6.0
    }
}

