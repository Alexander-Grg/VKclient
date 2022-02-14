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
    
    static let reusedIdentifier = "NewFriendsCell"
    @IBOutlet var nameView: UILabel!
    @IBOutlet var avatarView: AvatarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        avatarView.addGestureRecognizer(recognizer)
        avatarView.isUserInteractionEnabled = true
    }
    
    @objc func onTap() {
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
    //    MARK: - UserRealm for loading from R, UserObject for Network.
    
    func configure(_ friend: UserRealm) {
        nameView.text = "\(friend.firstName) \(friend.lastName)"
        let photoURL = URL(string: friend.avatar)
        avatarView.imageView.sd_setImage(with: photoURL)
    }
}
