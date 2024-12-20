//
//  LikeControl.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 29.11.2021.
//

import Foundation
import UIKit

protocol LikeControlDelegate: AnyObject {
    func didLike()
}

class LikeControl: UIControl {

// MARK: - Properties
    weak var delegate: LikeControlDelegate?
    private(set) lazy var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonHadler), for: .touchUpInside)


        button.setContentHuggingPriority(.defaultLow, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return button
    }()

    var isLiked: Bool? {
        didSet {
            updateButton()
        }
    }
    var likesCount: Int? {
        didSet {
            updateButton()
        }
    }

// MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureControl()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @objc func likeButtonHadler(_ sender: UIButton) {
        delegate?.didLike()
}

    func configureDataSource(with isLiked: Bool?, totalLikes: Int?) {
        self.isLiked = isLiked
        self.likesCount = totalLikes
    }

    private func configureControl() {
        self.addSubview(likeButton)
        self.isUserInteractionEnabled = true
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            likeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }

    private func updateButton() {
        let countText = likesCount.map { "\($0)" } ?? "0"
        let image = isLiked ?? false ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        likeButton.setImage(image, for: .normal)
        likeButton.setTitle(countText, for: .normal)
//        UIView.transition(with: self.likeButton,
//                         duration: 0.2,
//                         options: [.transitionFlipFromBottom]) {
//            self.likeButton.setTitle(countText, for: .normal)
//        }

        likeButton.setTitleColor(UIColor.black, for: .normal)
    }
}
