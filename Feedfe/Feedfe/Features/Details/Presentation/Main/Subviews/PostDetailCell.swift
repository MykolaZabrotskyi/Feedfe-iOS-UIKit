//
//  PostDetailCell.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

import UIKit
import Kingfisher

final class PostDetailCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.cornerRadius
        
        imageView.layer.borderWidth = Constant.borderWidth
        imageView.layer.borderColor = Constant.mainColor.cgColor
        
        imageView.backgroundColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = Constant.Font.title
        label.textColor = Constant.mainColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let textDescriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = Constant.Font.descriptionText
        label.textColor = UIColor.systemGray
        label.numberOfLines = 0
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
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure(with state: PostDetailViewState) {
        titleLabel.text = state.title
        textDescriptionLabel.text = state.text
        dateLabel.text = state.timestamp
        likesLabel.text = state.likesCount
        
        postImageView.kf.indicatorType = .activity
        postImageView.kf.setImage(
            with: state.postImage,
            placeholder: nil
        )
    }
}

// MARK: - Private Methods

private extension PostDetailCell {
    
    // MARK: - Setup
    
    func setupLayout() {
        contentView.addSubview(cellStackView)
        
        likesStackView.addArrangedSubview(likesImageView)
        likesStackView.addArrangedSubview(likesLabel)
        
        horizontalStackView.addArrangedSubview(likesStackView)
        horizontalStackView.addArrangedSubview(dateLabel)
        
        verticalStackView.addArrangedSubview(textDescriptionLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        cellStackView.addArrangedSubview(postImageView)
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            postImageView.heightAnchor.constraint(equalToConstant: Constant.postImageHeight),
            
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.padding),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.padding),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.padding)
        ])
    }
}

// MARK: - Constants

private extension PostDetailCell {
    enum Constant {
        static let mainColor = UIColor.systemIndigo
        static let cornerRadius: CGFloat = 6.0
        static let padding: CGFloat = 12.0
        static let postImageHeight: CGFloat = 250.0
        static let borderWidth: CGFloat = 6.0
        
        static let systemImage = UIImage(
            systemName: "heart",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        )
        
        enum Font {
            static let title = UIFont.systemFont(ofSize: 21, weight: .bold)
            static let descriptionText = UIFont.systemFont(ofSize: 18, weight: .regular)
            static let likesLabel = UIFont.systemFont(ofSize: 18, weight: .semibold)
            static let dateFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        }
        
        enum Spacing {
            static let likesStackView: CGFloat = 6.0
            static let verticalStackView: CGFloat = 12.0
            static let cellStackView: CGFloat = 18.0
        }
    }
}

