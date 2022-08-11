//
//  NewsTableViewCellPhoto.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 10.11.2021.
//

import UIKit
import SDWebImage

class NewsTableViewCellPhoto: UITableViewCell {

// MARK: - Properties

    private(set) lazy var newsPhoto: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .center
        photo.contentMode = .scaleToFill
        photo.semanticContentAttribute = .unspecified
        photo.alpha = 1
        photo.autoresizesSubviews = true
        photo.clipsToBounds = true

        return photo
    }()

// MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setView()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setView()
    }

// MARK: - UI

    private func setView() {
        self.isUserInteractionEnabled = false
        contentView.addSubview(newsPhoto)

        newsPhoto.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newsPhoto.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            newsPhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
            newsPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            newsPhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5)
        ])
    }

    func configure(_ image: News) {

        guard let imageURL = image.attachmentPhotoUrl else { return }
        newsPhoto.sd_setImage(with: imageURL)

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        newsPhoto.image = nil
    }
}

extension NewsTableViewCellPhoto: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
