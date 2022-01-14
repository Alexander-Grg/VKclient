//
//  NewsTableViewCellPost.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.12.2021.
//

import UIKit

class NewsTableViewCellPost: UITableViewCell {
    
    @IBOutlet var textForPost: UILabel! {
        didSet {
            textForPost.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet var showTextButton: UIButton! {
        didSet {
            showTextButton.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    static let reusedIdentifier = "NewsPostCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    override func prepareForReuse() {
//        textForPost.text = nil
//    }
    
    func configure(_ text: PostNews) {
        textForPost.text = text.text
    }
    
}
