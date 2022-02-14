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
        
        let avatarView = UIImageView()
        let postTimeLabel = UILabel()
        let userName = UILabel()
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
            self.addImageView()
            self.addTimeLabel()
            self.addUserNameLabel()
            self.setupConstraints()
        }

        private func addImageView() {
            self.avatarView.translatesAutoresizingMaskIntoConstraints = false
            self.avatarView.layer.cornerRadius = 10.0
            self.avatarView.clipsToBounds = true
            self.addSubview(self.avatarView)
        }
        
        private func addTimeLabel() {
            self.postTimeLabel.translatesAutoresizingMaskIntoConstraints = false
            self.postTimeLabel.font = UIFont.systemFont(ofSize: 14.0)
            self.postTimeLabel.textColor = .black
            self.postTimeLabel.numberOfLines = 1
            self.postTimeLabel.textAlignment = .left
            self.addSubview(self.postTimeLabel)
        }
        
        private func addUserNameLabel() {
            self.userName.translatesAutoresizingMaskIntoConstraints = false
            self.userName.font = UIFont.systemFont(ofSize: 14.0)
            self.userName.numberOfLines = 1
            self.userName.textColor = .black
            self.userName.textAlignment = .left
            self.addSubview(self.userName)
        }
        
        private func setupConstraints() {
            
            let l = safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                self.avatarView.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 5),
                self.avatarView.topAnchor.constraint(equalTo: l.topAnchor, constant: 5),
                self.avatarView.rightAnchor.constraint(equalTo: userName.leftAnchor),
                self.avatarView.widthAnchor.constraint(equalToConstant: 60),
                self.avatarView.heightAnchor.constraint(equalToConstant: 60),
                
                self.userName.leftAnchor.constraint(equalTo: avatarView.rightAnchor),
                self.userName.topAnchor.constraint(equalTo: l.topAnchor, constant: 5),
                self.userName.rightAnchor.constraint(equalTo: l.rightAnchor, constant: 0),
                
                self.postTimeLabel.leftAnchor.constraint(equalTo: avatarView.rightAnchor),
                self.postTimeLabel.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5),
                self.postTimeLabel.rightAnchor.constraint(equalTo: l.rightAnchor, constant: 0)
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
            userName.numberOfLines = 2
            userName.lineBreakMode = .byWordWrapping
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            postTimeLabel.text = dateFormatter.string(from: news.date)
        }
    }

