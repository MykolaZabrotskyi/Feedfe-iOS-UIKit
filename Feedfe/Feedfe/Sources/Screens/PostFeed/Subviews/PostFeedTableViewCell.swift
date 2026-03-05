//
//  PostFeedTableViewCell.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import UIKit

final class PostFeedTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemIndigo.withAlphaComponent(0.1)
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor.systemIndigo
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.systemGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let likesImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
        
        imageView.image = UIImage(systemName: "heart", withConfiguration: config)
        imageView.tintColor = .systemIndigo
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor.systemIndigo
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let likesStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    func configure(with model: PostFeedModel) {
        dateLabel.text = String(model.timestamp)
        titleLabel.text = model.title
        previewLabel.text = model.previewText
        likesLabel.text = String(model.likesCount)
        
    }
}

// MARK: - Private Methods

private extension PostFeedTableViewCell {
    func setupUI(){
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(cellStackView)
        
        likesStackView.addArrangedSubview(likesImageView)
        likesStackView.addArrangedSubview(likesLabel)
        
        horizontalStackView.addArrangedSubview(likesStackView)
        horizontalStackView.addArrangedSubview(dateLabel)
        
        verticalStackView.addArrangedSubview(previewLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(verticalStackView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            cellStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            cellStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            cellStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            cellStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }
}

private extension PostFeedTableViewCell {
    enum Constant {
        
    }
}
