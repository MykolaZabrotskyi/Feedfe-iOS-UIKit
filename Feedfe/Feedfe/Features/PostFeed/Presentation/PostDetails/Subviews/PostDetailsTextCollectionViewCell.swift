//
//  PostDetailsTextCollectionViewCell.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 12.03.2026.
//

import UIKit

final class PostDetailsTextCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let textDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.font
        label.textColor = Constant.color
        label.numberOfLines = 0
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
    
    func configure(with text: String) {
        textDescriptionLabel.text = text
    }
}

// MARK: - Private Methods

private extension PostDetailsTextCollectionViewCell {
    
    // MARK: - Setup
    
    func setupUI() {
        contentView.addSubview(textDescriptionLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            textDescriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - Constants

private extension PostDetailsTextCollectionViewCell {
    enum Constant {
        static let color = UIColor.systemGray
        static let font = UIFont.systemFont(ofSize: 18, weight: .regular)
    }
}

