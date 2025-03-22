//
//  PhotoPreviewView.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 15/3/25.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
import SDWebImage

final class PhotoPreviewView: UIView {

    private let stackView = UIStackView()
    private var imageViews: [UIImageView] = []
    private let noImagesLabel: UILabel = {
        let label = UILabel()
        label.text = "No images available"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    var images: [String] = [] {
        didSet {
            updateImages()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10

        addSubview(stackView)
        addSubview(noImagesLabel)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        noImagesLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            noImagesLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noImagesLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        for _ in 0..<3 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.isHidden = true // Initially hidden
            stackView.addArrangedSubview(imageView)
            imageViews.append(imageView)
        }
    }

    private func updateImages() {
        if images.isEmpty {
            noImagesLabel.isHidden = false
            stackView.isHidden = true
        } else {
            noImagesLabel.isHidden = true
            stackView.isHidden = false

            for (index, imageView) in imageViews.enumerated() {
                if index < images.count {
                    imageView.sd_setImage(with: URL(string: images[index]))
                    imageView.isHidden = false
                } else {
                    imageView.isHidden = true
                }
            }
        }
    }
}
