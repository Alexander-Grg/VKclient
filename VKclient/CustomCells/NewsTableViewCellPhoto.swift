//
//  NewsTableViewCellPhoto.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 10.11.2021.
//

import UIKit
import SDWebImage

class NewsTableViewCellPhoto: UITableViewCell{
    
    static let reuseIdentifier = "NewsPhotoCell"
    
    private(set) lazy var newsPhoto: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode = .center
        photo.contentMode = .scaleToFill
        photo.semanticContentAttribute = .unspecified
        photo.alpha = 1
        photo.autoresizesSubviews = true
        photo.clipsToBounds = true
        
        return photo
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setView()
  
      }
  
      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          self.setView()
      }
    
    func setView() {
        contentView.addSubview(newsPhoto)
        
        NSLayoutConstraint.activate([
            newsPhoto.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            newsPhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1),
            newsPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            newsPhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 1)
        ])
    }
    
    func configure(_ image: News) {
        let imageURL = image.url
        newsPhoto.sd_setImage(with: imageURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsPhoto.image = nil
    }
}
//class NewsTableViewCellPhoto: UITableViewCell{
////    MARK: - Properties
//    static let reuseIdentifier = "NewsPhotoCell"
//
//let newsPhoto: UIImageView = {
//        let photo = UIImageView()
//        photo.translatesAutoresizingMaskIntoConstraints = false
//        photo.contentMode = .center
//        photo.contentMode = .scaleToFill
//        photo.semanticContentAttribute = .unspecified
//        photo.alpha = 1
//        photo.autoresizesSubviews = true
//        photo.clipsToBounds = true
//
//        return photo
//    }()
//
////    MARK: - Lifecycle
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.configureUI()
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.configureUI()
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        newsPhoto.image = nil
//    }
//
////    MARK: - UI
//
//    private func configureUI() {
//        self.addSubviews()
//        self.setupConstraints()
//    }
//
//    private func addSubviews() {
//        self.addSubview(self.newsPhoto)
//    }
//
//    func setupConstraints() {
//
//        NSLayoutConstraint.activate([
//            newsPhoto.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
//            newsPhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1),
//            newsPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
//            newsPhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 1)
//        ])
//    }
//
//    func configureCell(_ image: PostNews) {
//        guard let imageURL = URL(string: image.urlString ?? "Error") else { return }
//        newsPhoto.sd_setImage(with: imageURL)
//    }
//}
