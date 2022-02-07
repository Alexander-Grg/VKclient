//
//  NewsTableViewCellPost.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.12.2021.
//

import UIKit
import SwiftUI

//protocol NewsText {
//    var newsText: String { get }
//}
//
//final class NewsTextCellModel: NewsText {
//    var newsText: String
//
//    init(newsText: String) {
//        self.newsText = newsText
//    }
//}

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
    
    func configure(_ postText: PostNews) {
                textForPost.text = postText.text
        
    
    }
    
    
}


//func configureText(textModel: NewsTextCellModel) {
//
//    let lenght = textModel.newsText.count
//    let maxlength = 200
//
//    if lenght <= maxlength {
//        newsLabel.text? = textModel.newsText
//
//    } else {
//
//        newsLabel.text? = textModel.newsText
//    let readmoreFont = UIFont(name: "Helvetica-Oblique", size: 11.0)
//    let readmoreFontColor = UIColor.blue
//    DispatchQueue.main.async {
//        self.newsLabel.addTrailing(with: "... ", moreText: "Readmore", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
//        }
//        }
//    }
//
//
//@objc func tappedShowMore() {
//    print("button tapped")
//}
//
//
//
//override func setSelected(_ selected: Bool, animated: Bool) {
//    super.setSelected(selected, animated: animated)
//
//    // Configure the view for the selected state
//}
//
//}
//
//extension String {
//func maxLength(length: Int) -> String {
//   var str = self
//   let nsString = str as NSString
//   if nsString.length >= length {
//       str = nsString.substring(with:
//           NSRange(
//            location: 0,
//            length: nsString.length > length ? length : nsString.length)
//       )
//   }
//   return  str
//}
//}
//
//
//extension UILabel {
//
//func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
//    let readMoreText: String = trailingText + moreText
//
//    let lengthForVisibleString: Int = self.visibleTextLength
//    let mutableString: String = self.text!
//    let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
//    let readMoreLength: Int = (readMoreText.count)
//    let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
//    let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
//    let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
//    answerAttributed.append(readMoreAttributed)
//    self.attributedText = answerAttributed
//}
//
//var visibleTextLength: Int {
//    let font: UIFont = self.font
//    let mode: NSLineBreakMode = self.lineBreakMode
//    let labelWidth: CGFloat = self.frame.size.width
//    let labelHeight: CGFloat = self.frame.size.height
//    let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
//
//    let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
//    let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
//    let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
//
//    if boundingRect.size.height > labelHeight {
//        var index: Int = 0
//        var prev: Int = 0
//        let characterSet = CharacterSet.whitespacesAndNewlines
//        repeat {
//            prev = index
//            if mode == NSLineBreakMode.byCharWrapping {
//                index += 1
//            } else {
//                index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
//            }
//        } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
//        return prev
//    }
//    return self.text!.count
//}
//}
