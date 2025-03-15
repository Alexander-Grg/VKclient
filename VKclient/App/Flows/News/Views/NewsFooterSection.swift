//
//  NewsFooterSection.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 10.11.2021.
//

import UIKit

final class NewsFooterSection: UITableViewCell {
    // MARK: - Properties
    weak var delegate: LikeControlDelegate?
    private(set) lazy var repostButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        button.setTitleColor(.black, for: .normal)

        return button
    }()

    private(set) lazy var commentsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.setTitleColor(.black, for: .normal)

        return button
    }()

    private(set) lazy var likesButton: LikeControl = {
        let likesControl = LikeControl()
        likesControl.translatesAutoresizingMaskIntoConstraints = false
        likesControl.isUserInteractionEnabled = true

        return likesControl
    }()

    private(set) lazy var viewsCounter: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setTitleColor(.black, for: .normal)

        return button
    }()

    // MARK: - Lifecycle

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
        self.viewsCounter.setTitle("0", for: .normal)
        self.repostButton.setTitle("0", for: .normal)
        self.commentsButton.setTitle("0", for: .normal)
        self.likesButton.likesCount = 0
        self.likesButton.isLiked = nil
    }

    // MARK: - UI

    private func configureUI() {
        self.selectionStyle = .none
        self.addSubviews()
        self.setupConstraints()
    }

    private func addSubviews() {
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addSubview(self.commentsButton)
        self.contentView.addSubview(self.likesButton)
        self.contentView.addSubview(self.repostButton)
        self.contentView.addSubview(self.viewsCounter)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.likesButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.likesButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 25),
            self.likesButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 5),

            self.commentsButton.leftAnchor.constraint(equalTo: likesButton.rightAnchor, constant: 25),
            self.commentsButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.commentsButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 5),

            self.repostButton.leftAnchor.constraint(equalTo: commentsButton.rightAnchor, constant: 25),
            self.repostButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.repostButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 5),

            self.viewsCounter.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            self.viewsCounter.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.viewsCounter.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 5)
        ])
    }

    func configureCell(_ data: News, currentLikeState: Likes?) {
        guard let likes = data.likes,
              let view = data.views,
              let reposts = data.reposts,
              let comments = data.comments
        else { return }

        self.viewsCounter.setTitle("\(view.count)", for: .normal)
        self.repostButton.setTitle("\(reposts.count)", for: .normal)
        self.commentsButton.setTitle("\(comments.count)", for: .normal)
        //        MARK: Configure likes control
        if let isLiked = currentLikeState,
           let canLike = isLiked.canLike == 1 ? false : true {
            self.likesButton.configureDataSource(with: canLike, totalLikes: likes.count)
        }
    }
}

extension NewsFooterSection: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
