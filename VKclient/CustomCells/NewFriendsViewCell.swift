//
//  NewFriendsViewCell.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 03.11.2021.
//

import Foundation
import UIKit
import SDWebImage

class NewFriendsViewCell: UITableViewCell {
    
    //    MARK: - Properties
    
    static let reusedIdentifier = "NewFriendsCell"

    private(set) lazy var nameView: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 17.0)
        l.textColor = .black
        l.textAlignment = .center
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 2
        
        return l
    }()
    
    private(set) lazy var avatarView: AvatarView = {
        let a = AvatarView()
        a.translatesAutoresizingMaskIntoConstraints = false
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        a.addGestureRecognizer(recognizer)
        a.isUserInteractionEnabled = true
        
        return a
    }()

    //    MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //    MARK: - Configuring UI
    
    private func configureUI() {
        self.addSubviews()
        self.setupConstraints()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.avatarView)
        self.contentView.addSubview(self.nameView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            self.avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            self.avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            self.avatarView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            self.avatarView.rightAnchor.constraint(equalTo: nameView.leftAnchor),
            self.avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor, multiplier: 1.0),
            
            self.nameView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.nameView.leftAnchor.constraint(equalTo: avatarView.rightAnchor, constant: 10),
            self.nameView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10)
        ])
    }
    
//    MARK: - Private methods
    
    @objc private func onTap() {
        avatarAnimation()
    }
    
    @objc private func avatarAnimation() {
        avatarView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 1.6,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.2,
                       options: .curveEaseOut,
                       animations: {
            self.avatarView.transform = CGAffineTransform(scaleX: 1, y: 1)}
                       ,completion: nil)
    }
    
    func configure(_ friend: UserRealm) {
        nameView.text = "\(friend.firstName) \(friend.lastName)"
        let photoURL = URL(string: friend.avatar)
        avatarView.imageView.sd_setImage(with: photoURL)
    }
}
