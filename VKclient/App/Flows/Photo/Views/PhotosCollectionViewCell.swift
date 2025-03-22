//
//  PhotosCollectionViewCell.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 07.09.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

final class PhotosCollectionViewCell: UICollectionViewCell {

// MARK: - Properties

    private enum Constants {
        static let contentViewCornerRadius: CGFloat = 4.0
        static let imageHeight: CGFloat = 180.0
        static let verticalSpacing: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 16.0
        static let profileDescriptionVerticalPadding: CGFloat = 8.0
    }

    private(set) lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private(set) lazy var likeControl: LikeControl = {
        let control = LikeControl()

        return control
    }()

// MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayouts()
    }

// MARK: - UI

    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.backgroundColor = .white

        contentView.addSubview(profileImageView)

    }

    private func setupLayouts() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotosCollectionViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
