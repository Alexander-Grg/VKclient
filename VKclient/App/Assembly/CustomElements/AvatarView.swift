//
//  AvatarView.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 06.09.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

final class AvatarView: UIView {

   private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private(set) lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.backgroundColor = .clear
        shadowView.clipsToBounds = false

        return shadowView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraint()
    }

    func setImage(_ image: UIImage?) {
        imageView.image = image
    }

    private func setupViews() {
        addSubview(shadowView)
        shadowView.addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        viewSettings()
    }

    private func setupConstraint() {

        shadowView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.leftAnchor.constraint(equalTo: leftAnchor),
            shadowView.rightAnchor.constraint(equalTo: rightAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor)
        ])
    }

    private func viewSettings() {
        backgroundColor = .clear
        imageView.layer.cornerRadius = bounds.height / 2
        shadowView.layer.cornerRadius = bounds.height / 2
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.shadowRadius = 8
    }
}
