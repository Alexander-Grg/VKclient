//
//  LikeControl.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 29.11.2021.
//

import Foundation
import UIKit

class LikeControl: UIControl {
    
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            self.likeButton.addTarget(self, action: #selector(likeButtonHadler(_:)), for: .touchUpInside)
        }
    }
    
    
    var isLiked: Bool = false
    
    var likesCount: Int = 0 {
        didSet {
            likeButton.setTitle("\(self.likesCount)", for: .normal)
            UIView.transition(with: self.likeButton,
                              duration: 0.2,
                              options: [.transitionFlipFromBottom]) {
                self.likeButton.setTitle("\(self.likesCount)", for: .normal)
            }
            let image = self.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            let textColor = self.isLiked ? UIColor.red : UIColor.secondaryLabel
            self.likeButton.setImage(image, for: .normal)
            self.likeButton.setTitleColor(textColor, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func likeButtonHadler(_ sender: UIButton) {
        isLiked.toggle()
        isLiked ? self.likesCount += 1 : self.likesCount > 0 ? self.likesCount -= 1 : nil
    }
    
}
