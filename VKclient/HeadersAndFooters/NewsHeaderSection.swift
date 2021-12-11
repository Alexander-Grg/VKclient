//
//  NewsHeaderSection.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 10.11.2021.
//

import UIKit
import SDWebImage

class NewsHeaderSection: UITableViewCell {
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var postTimeLabel: UILabel!
    @IBOutlet var userName: UILabel!
    static let reuseIdentifier = "NewsHeaderSection"
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postTimeLabel.text = nil
        userName.text = nil
        avatarView.image = nil
    }
    
    func configure(_ news: PostNews) {
        if let exactNews = news.urlProtocol {
            avatarView.sd_setImage(with: exactNews.urlImage)
            userName.text = exactNews.name
        } else {
            avatarView.sd_setImage(with: URL(string: "Error"))
            userName.text = "Error, data not found"
        }
        userName.numberOfLines = 2
        userName.lineBreakMode = .byWordWrapping
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        postTimeLabel.text = dateFormatter.string(from: news.date)
    }
}

