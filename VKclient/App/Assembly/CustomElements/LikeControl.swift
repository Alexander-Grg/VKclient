//
//  LikeControl.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 29.11.2021.
//

import Foundation
import UIKit

protocol LikeControlDelegate: AnyObject {
    func didLike(in cell: NewsFooterSection?)
}

class LikeControl: UIControl {

// MARK: - Properties
    weak var delegate: LikeControlDelegate?
    private(set) lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setContentHuggingPriority(.defaultLow, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return button
    }()

    var isLiked: Bool?
    var likesCount = 0

// MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeButtonHandler))
        self.addGestureRecognizer(gestureRecognizer)
        self.configureControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureControl()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @objc func likeButtonHandler() {
        if let cell = self.superview?.superview as? NewsFooterSection {
            delegate?.didLike(in: cell)
        }
}

    func configureDataSource(with isLiked: Bool?, totalLikes: Int?) {
        self.isLiked = isLiked
        self.likesCount = totalLikes ?? 0
        self.updateButton()
    }

    private func configureControl() {
        self.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            likeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.widthAnchor.constraint(equalTo: likeButton.widthAnchor),
            self.heightAnchor.constraint(equalTo: likeButton.heightAnchor)
        ])

        self.isUserInteractionEnabled = true
        likeButton.isUserInteractionEnabled = false
    }

    private func updateButton() {
        let countText = "\(likesCount)"
        let image = isLiked ?? false ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeButton.setImage(image, for: .normal)
        likeButton.setTitle(countText, for: .normal)
        UIView.transition(with: self.likeButton,
                         duration: 0.2,
                         options: [.transitionFlipFromBottom]) {
            self.likeButton.setTitle(countText, for: .normal)
        }

        likeButton.setTitleColor(UIColor.black, for: .normal)
    }
}
