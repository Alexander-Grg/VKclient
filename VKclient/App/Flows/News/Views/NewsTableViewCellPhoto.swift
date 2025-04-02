//
//  NewsTableViewCellPhoto.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 10.11.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
import SDWebImage

protocol NewsTableViewCellPhotoDelegate: AnyObject {
    func didTapPhotoCell(images: [String], index: Int)
}

final class NewsTableViewCellPhoto: UITableViewCell {
    
    weak var delegate: NewsTableViewCellPhotoDelegate?
    
    // MARK: - Properties
    private(set) lazy var newsPhoto: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .center
        photo.contentMode = .scaleAspectFill
        photo.semanticContentAttribute = .unspecified
        photo.alpha = 1
        photo.autoresizesSubviews = true
        photo.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        tapGestureRecognizer.delegate = self
        photo.addGestureRecognizer(tapGestureRecognizer)
        photo.isUserInteractionEnabled = true

        return photo
    }()
    
    private(set) lazy var tapLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.text = "Tap to see a full image"
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        tapGestureRecognizer.delegate = self
        label.addGestureRecognizer(tapGestureRecognizer)
        label.isUserInteractionEnabled = true

        return label
    }()
    
    private var images: [String] = []
    private var currentIndex: Int = 0
    
    
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
        contentView.addSubview(tapLabel)
        contentView.addSubview(newsPhoto)
        self.selectionStyle = .none

        newsPhoto.translatesAutoresizingMaskIntoConstraints = false
        tapLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsPhoto.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            newsPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            newsPhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            tapLabel.topAnchor.constraint(equalTo: newsPhoto.bottomAnchor, constant: 5),
            tapLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            tapLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            tapLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func configure(images: [String], index: Int) {
        guard !images.isEmpty,
              let urlOfTheFirstImage = URL(string: images.first ?? "")
        else { return }
        
        newsPhoto.sd_setImage(with: urlOfTheFirstImage)
        self.currentIndex = index
        self.images = images
    }
    
    @objc private func didTapPhoto() {
        delegate?.didTapPhotoCell(images: self.images, index: self.currentIndex)
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
