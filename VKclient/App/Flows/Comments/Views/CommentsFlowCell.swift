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
        private(set) lazy var mainTextLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
    //        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentButtonHandler))
    //        self.addGestureRecognizer(gestureRecognizer)
            self.configureUI()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    //    @objc func commentButtonHandler() {
    //        if let cell = self.superview?.superview as? NewsFooterSection {
    //            delegate?.didTapComment(in: cell)
    //        }
    //    }

        func configureData(with comment: Comment) {
            self.mainTextLabel.text = comment.text
        }

        private func configureUI() {
            self.contentView.addSubview(self.mainTextLabel)
            self.setupConstraints()
        }

        private func setupConstraints() {
            NSLayoutConstraint.activate([
                self.mainTextLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
                self.mainTextLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
                self.mainTextLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
                self.self .bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
            ])
        }
    }

    extension CommentsFlowCell: ReusableView {
        static var identifier: String {
            return String(describing: self)
        }

    }

