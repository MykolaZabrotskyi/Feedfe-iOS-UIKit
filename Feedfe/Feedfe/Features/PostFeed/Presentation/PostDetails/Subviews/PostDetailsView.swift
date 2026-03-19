//
//  PostDetailsView.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 12.03.2026.
//

import UIKit
import Kingfisher

final class PostDetailsView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.title
        label.textColor = Constant.Color.main
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.text
        label.textColor = Constant.Color.second
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.likesIcon
        imageView.tintColor = Constant.Color.main
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.likes
        label.textColor = Constant.Color.main
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.cornerRadius
        imageView.layer.borderWidth = Constant.borderWidth
        imageView.layer.borderColor = Constant.Color.main.cgColor
        imageView.backgroundColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.date
        label.textColor = Constant.Color.third
        label.numberOfLines = 1
        label.textAlignment = .right
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
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = Constant.Spacing.textStackView
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constant.Spacing.mainStackView
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let spacerView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Configuration
    
    func configure(with viewState: PostDetailsViewState) {
        postImageView.kf.indicatorType = .activity
        postImageView.kf.setImage(with: viewState.image, placeholder: nil)
        
        titleLabel.text = viewState.title
        textLabel.text = viewState.text
        likesLabel.text = viewState.likesCount
        dateLabel.text = viewState.date
    }
}

// MARK: - Private Methods

private extension PostDetailsView {
    
    // MARK: - Setup
    
    func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(scrollView)
        
        likesStackView.addArrangedSubview(likesImageView)
        likesStackView.addArrangedSubview(likesLabel)
        
        dateStackView.addArrangedSubview(likesStackView)
        dateStackView.addArrangedSubview(dateLabel)
        
        textStackView.addArrangedSubview(textLabel)
        textStackView.addArrangedSubview(spacerView)
        textStackView.addArrangedSubview(dateStackView)
        
        mainStackView.addArrangedSubview(postImageView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(textStackView)
        
        scrollView.addSubview(mainStackView)
    }
    
    func setupLayout() {
        let contentGuide = scrollView.contentLayoutGuide
        let frameGuide = scrollView.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: contentGuide.topAnchor, constant: Constant.Spacing.padding),
            mainStackView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor, constant: Constant.Spacing.padding),
            mainStackView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor, constant: -Constant.Spacing.padding),
            mainStackView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor, constant: -Constant.Spacing.padding),
            
            mainStackView.widthAnchor.constraint(equalTo: frameGuide.widthAnchor, constant: -(Constant.Spacing.padding * 2)),
            mainStackView.heightAnchor.constraint(greaterThanOrEqualTo: frameGuide.heightAnchor, constant: -(Constant.Spacing.padding * 2)),
            
            postImageView.heightAnchor.constraint(equalToConstant: Constant.postImageHeight)
        ])
    }
}

// MARK: - Constants

private extension PostDetailsView {
    enum Constant {
        static let cornerRadius: CGFloat = 6.0
        static let borderWidth: CGFloat = 6.0
        static let postImageHeight: CGFloat = 250.0
        
        static let likesIcon = UIImage(
            systemName: "heart",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        )
        
        enum Color {
            static let main = UIColor.systemIndigo
            static let second = UIColor.systemGray
            static let third = UIColor.systemGray2
        }
        
        enum Font {
            static let title = UIFont.systemFont(ofSize: 21, weight: .bold)
            static let text = UIFont.systemFont(ofSize: 18, weight: .regular)
            static let likes = UIFont.systemFont(ofSize: 18, weight: .semibold)
            static let date = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        
        enum Spacing {
            static let likesStackView: CGFloat = 6.0
            static let mainStackView: CGFloat = 12.0
            static let textStackView: CGFloat = 12.0
            static let padding: CGFloat = 15.0
        }
    }
}
