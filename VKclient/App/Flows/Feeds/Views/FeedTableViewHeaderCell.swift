//
//  NewsHeaderSection.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 10.11.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
import SDWebImage

final class FeedTableViewHeaderCell: UITableViewCell {

    private(set) lazy var avatarView: UIImageView = {
        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 10.0
        avatar.clipsToBounds = true

        return avatar
    }()

    private(set) lazy var postTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.textAlignment = .left

        return label
    }()

    private(set) lazy var userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.textAlignment = .left

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postTimeLabel.text = nil
        userName.text = nil
        avatarView.image = nil
    }

    private func configureUI() {
        self.addSubviews()
        self.setupConstraints()
    }

    private func addSubviews() {
        self.contentView.addSubview(self.avatarView)
        self.contentView.addSubview(self.postTimeLabel)
        self.contentView.addSubview(self.userName)
    }

    private func setupConstraints() {
        self.selectionStyle = .none
        NSLayoutConstraint.activate([
            self.avatarView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            self.avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            self.avatarView.rightAnchor.constraint(equalTo: userName.leftAnchor),
            self.avatarView.widthAnchor.constraint(equalToConstant: 60),
            self.avatarView.heightAnchor.constraint(equalToConstant: 60),
            self.userName.leftAnchor.constraint(equalTo: avatarView.rightAnchor),
            self.userName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            self.userName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            self.postTimeLabel.leftAnchor.constraint(equalTo: avatarView.rightAnchor),
            self.postTimeLabel.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5),
            self.postTimeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0)
        ])
    }
    func configureCell(_ news: Post, user: UserRealm?) {
        if let exactNews = news.urlProtocol {
            avatarView.sd_setImage(with: exactNews.urlImage)
            userName.text = exactNews.name
        } else if let user = user {
            let url = URL(string: user.avatar)
            if let url = url {
                avatarView.sd_setImage(with: url)
            } else {
                avatarView.isHidden = true
            }
            userName.text = user.firstName + " " + user.lastName
        } else {
            avatarView.isHidden = true
            userName.isHidden = true
        }

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        let date = Date(timeIntervalSince1970: news.date ?? 0.0)
        postTimeLabel.text = dateFormatter.string(from: date)
    }
}

extension FeedTableViewHeaderCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
