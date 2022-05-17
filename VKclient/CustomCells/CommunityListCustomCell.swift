//
//  CommunityListCustomCell.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 17.05.2022.
//

import UIKit

class CommunityListCustomCell: UITableViewCell {
    
//    MARK: - Properties
    
    static let reusedIdentifier = "communityCell"
    
    private(set) lazy var avatar: AvatarView = {
            let a = AvatarView()
            a.translatesAutoresizingMaskIntoConstraints = false
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.buttonTap))
            recognizer.numberOfTapsRequired = 1
            recognizer.numberOfTouchesRequired = 1
            a.addGestureRecognizer(recognizer)
            a.isUserInteractionEnabled = true

            return a
        }()
    
    private(set) lazy var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16.0)
        l.textColor = .black
        l.textAlignment = .center
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 2
        
        return l
    }()
    
//    MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
//    MARK: - UI
    
    private func configureUI() {
        self.addSubviews()
        self.setupConstraint()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.avatar)
        self.contentView.addSubview(self.label)
    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            self.avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            self.avatar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            self.avatar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            self.avatar.rightAnchor.constraint(equalTo: self.label.leftAnchor),
            self.avatar.heightAnchor.constraint(equalToConstant: 60),
            self.avatar.widthAnchor.constraint(equalToConstant: 60),
            self.avatar.heightAnchor.constraint(equalTo: self.avatar.widthAnchor, multiplier: 1.0),
            
            self.label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.label.leftAnchor.constraint(equalTo: self.avatar.rightAnchor, constant: 10),
            self.label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10)

        ])
    }
    
   @objc private func buttonTap() {
        self.avatarAnimation()
    }
    
    
    @objc private func avatarAnimation() {
        avatar.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 1.6,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.2,
                       options: .curveEaseOut,
                       animations: {
            self.avatar.transform = CGAffineTransform(scaleX: 1, y: 1)}
                       ,completion: nil)
        
    }
    
    func configureCell(_ data: GroupsObjects ) {
        let image = URL(string: data.photo)
        avatar.imageView.sd_setImage(with: image)
        self.label.text = data.name
    }
}
