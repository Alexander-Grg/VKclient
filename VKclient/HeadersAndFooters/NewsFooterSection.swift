//
//  NewsFooterSection.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 10.11.2021.
//

import UIKit

class NewsFooterSection: UITableViewCell {
    static let reuseIdentifier = "NewsFooter"
    @IBOutlet var repostButton: UIButton!
    @IBOutlet var commentsButton: UIButton!
    @IBOutlet var likesButton: LikeControl!
    @IBOutlet var viewsCounter: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewsCounter.setTitle("0", for: .normal)
        repostButton.setTitle("0", for: .normal)
        commentsButton.setTitle("0", for: .normal)
    }
    
    func configure(_ data: PostNews) {
        viewsCounter.setTitle("\(data.views.description)", for: .normal)
        repostButton.setTitle("\(data.reposts)", for: .normal)
        commentsButton.setTitle("\(data.comments)", for: .normal)
    }
    
}

