//
//  NewsTableViewCellPost.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.12.2021.
//

import UIKit
import SwiftUI

protocol NewsDelegate {
    func buttonTapped(cell: NewsTableViewCellPost)
}

class NewsTableViewCellPost: UITableViewCell {
    
    //    MARK: - Properties
    
  

    static let reusedIdentifier = "NewsPostCell"
    var isPressed: Bool = false
    var delegate: NewsDelegate?
    
   let textForPost: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16.0)
        l.textColor = .black
        l.lineBreakMode = .byClipping
        l.contentMode = .scaleToFill
        l.numberOfLines = 0
        l.textAlignment = .left
        
        return l
    }()
    
  let showMoreTextButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitleColor(UIColor.systemBlue, for: .normal)
//        b.isUserInteractionEnabled = true
        
        return b
        
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
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.textForPost.text = nil
//    }
    
    //    MARK: - Configuring UI
    
    private func configureUI() {
        self.addSubviews()
        self.setupConstraints()
//        self.addTapp()
    }
    
    private func addSubviews() {
        self.addSubview(self.showMoreTextButton)
        self.addSubview(self.textForPost)
    }
    
//    func addTapp() {
//        showMoreTextButton.addTarget(self, action: #selector(self.buttonTap), for: .touchUpInside)
//    }
 
    @objc func buttonTap(_ sender: Any?) {
        if sender is UIButton {
            isPressed = !isPressed
            showMoreTextButton.setTitle(buttonStateName(), for: .normal)
        }
        delegate?.buttonTapped(cell: self)
    }
    
    private func setupConstraints() {
        
        let s = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            textForPost.topAnchor.constraint(equalTo: s.topAnchor, constant: 15),
            textForPost.leftAnchor.constraint(equalTo: s.leftAnchor, constant: 15),
            textForPost.rightAnchor.constraint(equalTo: s.rightAnchor, constant: 15),
            textForPost.bottomAnchor.constraint(equalTo: showMoreTextButton.topAnchor),
            
            showMoreTextButton.topAnchor.constraint(equalTo: textForPost.bottomAnchor),
            showMoreTextButton.widthAnchor.constraint(equalToConstant: 150),
            showMoreTextButton.heightAnchor.constraint(equalToConstant: 30),
            showMoreTextButton.rightAnchor.constraint(equalTo: s.rightAnchor, constant: 10),
            showMoreTextButton.bottomAnchor.constraint(equalTo: s.bottomAnchor, constant: 5)
        ])
    }
    
    //    MARK: - Configuring cell
    
    func configureCell(_ postText: PostNews, isTapped: Bool) {
        textForPost.text = postText.text
        if isTapped {
            isPressed = false
            showMoreTextButton.setTitle(buttonStateName(), for: .normal)
            showMoreTextButton.isHidden = false
        } else {
            showMoreTextButton.isHidden = true
        }
    }
    
    private func buttonStateName() -> String {
        isPressed ? "Show Less": "Show More"
    }
    
    }

