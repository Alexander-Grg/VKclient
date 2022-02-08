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
    
    let textForPost = UILabel()
    let showMoreTextButton = UIButton()
    static let reusedIdentifier = "NewsPostCell"
    var isPressed: Bool = false
    var delegate: NewsDelegate?
    
    //    MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ text: PostNews) {
        textForPost.text = text.text
        textForPost.textAlignment = .center
        textForPost.textColor = .black
        textForPost.lineBreakMode = .byClipping
        textForPost.contentMode = .scaleToFill
        textForPost.numberOfLines = 0
    }
    
    //    MARK: - Configuring UI
    
    private func configureUI() {
        self.addTextLabel()
        self.addShowMoreButton()
        self.setupConstraints()
    }
    
    private func addTextLabel() {
        self.textForPost.translatesAutoresizingMaskIntoConstraints = false
        textForPost.font = UIFont.systemFont(ofSize: 16.0)
        textForPost.textColor = .black
        textForPost.lineBreakMode = .byClipping
        textForPost.contentMode = .scaleToFill
        textForPost.numberOfLines = 0
        textForPost.sizeToFit()
        self.addSubview(self.textForPost)
    }
    
    private func addShowMoreButton() {
        self.showMoreTextButton.translatesAutoresizingMaskIntoConstraints = false
        showMoreTextButton.setTitleColor(UIColor.systemBlue, for: .normal)
        showMoreTextButton.addTarget(self, action: #selector(self.buttonTap), for: .touchUpInside)
        self.addSubview(self.showMoreTextButton)
    }
    
    @objc func buttonTap(_ sender: Any?) {
        if sender is UIButton {
            isPressed = !isPressed
            showMoreTextButton.setTitle(buttonStateName(), for: .normal)
        }
        delegate?.buttonTapped(cell: self)
    }
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            textForPost.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            textForPost.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10),
            textForPost.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 10),
            textForPost.bottomAnchor.constraint(equalTo: showMoreTextButton.topAnchor),
            
            showMoreTextButton.topAnchor.constraint(equalTo: textForPost.bottomAnchor),
            showMoreTextButton.widthAnchor.constraint(equalToConstant: 150),
            showMoreTextButton.heightAnchor.constraint(equalToConstant: 30),
            showMoreTextButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 10),
            showMoreTextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 5)
        ])
    }
    
    //    MARK: - Configuring cell
    
    func configure(_ postText: PostNews, isTapped: Bool) {
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

