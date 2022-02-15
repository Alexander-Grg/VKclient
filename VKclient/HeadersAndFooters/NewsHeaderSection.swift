//
//  NewsHeaderSection.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 10.11.2021.
//

import UIKit
import SDWebImage

class NewsHeaderSection: UITableViewCell {
    //    MARK: - Properties

    let avatarView: UIImageView = {
        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 10.0
        avatar.clipsToBounds = true
        
        return avatar
    }()
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.textAlignment = .left
        
        return label
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.textAlignment = .left
        
        return label
    }()

    static let reuseIdentifier = "NewsHeaderSection"
    
    //    MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postTimeLabel.text = nil
        userName.text = nil
        avatarView.image = nil
    }
    
    //    MARK: - UI
    
    private func configureUI() {
        self.addSubviews()
        self.setupConstraints()
    }
    
    private func addSubviews(){
        self.addSubview(self.avatarView)
        self.addSubview(self.postTimeLabel)
        self.addSubview(self.userName)
    }
    
    
    private func setupConstraints() {
        
        let s = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.avatarView.leftAnchor.constraint(equalTo: s.leftAnchor, constant: 5),
            self.avatarView.topAnchor.constraint(equalTo: s.topAnchor, constant: 5),
            self.avatarView.rightAnchor.constraint(equalTo: userName.leftAnchor),
            self.avatarView.widthAnchor.constraint(equalToConstant: 60),
            self.avatarView.heightAnchor.constraint(equalToConstant: 60),
            
            self.userName.leftAnchor.constraint(equalTo: avatarView.rightAnchor),
            self.userName.topAnchor.constraint(equalTo: s.topAnchor, constant: 5),
            self.userName.rightAnchor.constraint(equalTo: s.rightAnchor, constant: 0),
            
            self.postTimeLabel.leftAnchor.constraint(equalTo: avatarView.rightAnchor),
            self.postTimeLabel.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5),
            self.postTimeLabel.rightAnchor.constraint(equalTo: s.rightAnchor, constant: 0)
        ])
    }
    
    func configureCell(_ news: PostNews) {
        if let exactNews = news.urlProtocol {
            avatarView.sd_setImage(with: exactNews.urlImage)
            userName.text = exactNews.name
        } else {
            avatarView.sd_setImage(with: URL(string: "Error"))
            userName.text = "Error, data not found"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        postTimeLabel.text = dateFormatter.string(from: news.date)
    }
}

