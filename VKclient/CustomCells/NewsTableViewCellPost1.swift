//
//  NewsCollectionViewCell.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 16.09.2021.
//

import UIKit

//class NewsTableViewCellPost1: UITableViewCell {
//
//    static let reusedIdentifier = "NewsPostCell"
//
//    let label: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .center
//        label.textColor = .black
//        label.lineBreakMode = .byClipping
//        label.contentMode = .scaleToFill
//        label.numberOfLines = 0
//        return label
//    }()
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setUpViews()
//
//    }
//
//    private func setUpViews() {
//
//        contentView.addSubview(label)
//
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
//            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
//            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)
//        ])
//    }
//
//    func configure(_ text: PostNews) {
//        label.text = text.text
//    }
//
//    override func prepareForReuse() {
//        label.text = nil
//    }
//}
//
//
