//
//  NewsTableViewCellPost.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.12.2021.
//

import UIKit
import SwiftUI

extension NewsTableViewCellPost {
     struct Constants {
         static let insets = UIEdgeInsets(top: 15.0,
                                          left: 10.0,
                                          bottom: 15.0,
                                          right: 10.0)
         static let oneOffset: CGFloat = 10.0
    }
}

class NewsTableViewCellPost: UITableViewCell {
    
    @IBOutlet var textForPost: UILabel!
//    {
//        didSet {
//            textForPost.translatesAutoresizingMaskIntoConstraints = false
//        }
//    }
    @IBOutlet var showTextButton: UIButton!
//    {
//        didSet {
//            showTextButton.translatesAutoresizingMaskIntoConstraints = false
//        }
//    }
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
//    
//    private func calculateTextSize(text: String, font: UIFont) -> CGSize {
//        let maxWidth = bounds.width - Constants.oneOffset * 2
//        let textBlock = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
//        let textRect = text.boundingRect(with: textBlock,
//                                         attributes: [NSAttributedString.Key.font : font],
//                                         context: nil)
//        return CGSize(
//            width: textRect.size.width,
//            height: textRect.size.height)
//    }
//    
//    private func postLabelFrame() {
//        let postLabelFrame = calculateTextSize(
//            text: textForPost.text,
//            font: textForPost.font)
//        let postLabelX = (bounds.width - postLabelFrame) / 2
//        
//        let postLabelY = bounds.height - postLabelFrame.height
//    }
    
}
