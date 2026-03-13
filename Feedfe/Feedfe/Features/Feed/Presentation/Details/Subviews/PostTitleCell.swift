//
//  PostTitleCell.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 12.03.2026.
//

import UIKit

final class PostTitleCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
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
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - Private Methods

private extension PostTitleCell {
    
    // MARK: - Setup
    
    func setupUI() {
        contentView.addSubview(titleLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - Constants

private extension PostTitleCell {
    enum Constant {
        static let color = UIColor.systemIndigo
        static let font = UIFont.systemFont(ofSize: 21, weight: .bold)
    }
}

