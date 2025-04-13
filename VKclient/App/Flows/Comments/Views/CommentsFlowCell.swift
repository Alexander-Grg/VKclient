//
//
//  CommentsFlowCell.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.03.2025.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//

    import UIKit

    final class CommentsFlowCell: UITableViewCell {

        private(set) lazy var nameTextLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = .black
            return label
        }()

        private(set) lazy var mainTextLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .black
            return label
        }()

        private(set) lazy var mainDateLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .gray
            label.text = "TEST"
            return label
        }()

        private(set) lazy var likesButton: LikeControl = {
            let likesControl = LikeControl()
            likesControl.translatesAutoresizingMaskIntoConstraints = false
            likesControl.isUserInteractionEnabled = true

            return likesControl
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.configureUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            self.nameTextLabel.text = ""
            self.mainDateLabel.text = ""
            self.likesButton.isLiked = false
            self.likesButton.likesCount = 0
            self.mainTextLabel.text = ""
        }

        func configureData(with comment: CommentModel, with profile: UserModel) {
            guard
            !profile.firstName.isEmpty,
            !profile.lastName.isEmpty,
            !comment.text.isEmpty
            else { return }
            self.nameTextLabel.text = "\(profile.firstName) \(profile.lastName)"
            self.mainTextLabel.text = comment.text
            if let likes = comment.likes {
                self.likesButton.configureDataSource(with:comment.isLiked, totalLikes: likes.userLikes)
            }
    }

        private func configureUI() {
            self.contentView.addSubview(self.nameTextLabel)
            self.contentView.addSubview(self.mainDateLabel)
            self.contentView.addSubview(self.likesButton)
            self.contentView.addSubview(self.mainTextLabel)
            self.setupConstraints()
        }

        private func setupConstraints() {
            NSLayoutConstraint.activate([
                nameTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                nameTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                nameTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: mainDateLabel.leadingAnchor, constant: -8),

                mainDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                mainDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

                mainTextLabel.topAnchor.constraint(equalTo: nameTextLabel.bottomAnchor, constant: 4),
                mainTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                mainTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                mainTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

                likesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                likesButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
        }
    }

    extension CommentsFlowCell: ReusableView {
        static var identifier: String {
            return String(describing: self)
        }

    }

