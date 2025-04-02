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

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.configureUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureData(with comment: CommentModel, with profiles: [Int: UserModel]) {
            self.mainTextLabel.text = comment.text

            if let profile = profiles[comment.id] {
                self.nameTextLabel.text = "\(profile.firstName) \(profile.lastName)"
            } else {
                self.nameTextLabel.text = "Unknown User"
            }
        }

        private func configureUI() {
            self.contentView.addSubview(self.nameTextLabel)
            self.contentView.addSubview(self.mainTextLabel)
            self.setupConstraints()
        }

        private func setupConstraints() {
            NSLayoutConstraint.activate([
                nameTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                nameTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                nameTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

                mainTextLabel.topAnchor.constraint(equalTo: nameTextLabel.bottomAnchor, constant: 4),
                mainTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                mainTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                mainTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
        }
    }

    extension CommentsFlowCell: ReusableView {
        static var identifier: String {
            return String(describing: self)
        }

    }

