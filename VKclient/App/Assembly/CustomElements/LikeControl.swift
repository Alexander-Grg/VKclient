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

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        print("Hit test for LikeControl: \(String(describing: view))")
        return view
    }

    @objc func likeButtonHandler() {
        if let cell = self.superview?.superview as? NewsFooterSection {
            delegate?.didLike(in: cell)
        }
}

    func configureDataSource(with isLiked: Bool?, totalLikes: Int?) {
        self.isLiked = isLiked
        self.likesCount = totalLikes
    }

    private func configureControl() {
        self.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            likeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),

            self.widthAnchor.constraint(equalToConstant: 40),
            self.heightAnchor.constraint(equalToConstant: 40)
        ])

        self.isUserInteractionEnabled = true
        likeButton.isUserInteractionEnabled = false
    }

    private func updateButton() {
        let countText = likesCount.map { "\($0)" } ?? "0"
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
