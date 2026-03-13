//
//  PostDetailsDateCollectionViewCell.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 12.03.2026.
//

import UIKit

final class PostDetailsDateCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.font
        label.textColor = Constant.color
        label.numberOfLines = 1
        label.textAlignment = .right
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
    
    func configure(date: String) {
        dateLabel.text = date
    }
}

// MARK: - Private Methods

private extension PostDetailsDateCollectionViewCell {
    
    // MARK: - Setup
    
    func setupUI(){
        contentView.addSubview(dateLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - Constants

private extension PostDetailsDateCollectionViewCell {
    enum Constant {
        static let color = UIColor.systemGray2
        static let font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
}
