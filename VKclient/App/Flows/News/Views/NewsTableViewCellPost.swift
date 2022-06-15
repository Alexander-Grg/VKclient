//
//  NewsTableViewCellPost.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.12.2021.
//

import UIKit

protocol NewsDelegate {
    func buttonTapped(cell: NewsTableViewCellPost)
}

class NewsTableViewCellPost: UITableViewCell {
    
    //    MARK: - Properties

    var isPressed: Bool = false
    var delegate: NewsDelegate?
    
    private(set) lazy var textForPost: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16.0)
        l.textColor = .black
        l.contentMode = .scaleToFill
        l.numberOfLines = 0
        l.textAlignment = .left
        l.sizeToFit()
        return l
    }()
    
    private(set) lazy var showMoreTextButton: UIButton = {
        let b = UIButton()
        b.setTitleColor(UIColor.systemBlue, for: .normal)
        b.addTarget(self, action: #selector(self.buttonTap) , for: .touchUpInside)
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
    
    //    MARK: - Configuring UI
    
    private func configureUI() {
        self.addSubviews()
        self.setupConstraints()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.showMoreTextButton)
        self.contentView.addSubview(self.textForPost)
    }
    
    @objc private func buttonTap() {
        isPressed = !isPressed
        showMoreTextButton.setTitle(buttonStateName(), for: .normal)
        delegate?.buttonTapped(cell: self)
    }
    
    private func setupConstraints() {
        
        textForPost.translatesAutoresizingMaskIntoConstraints = false
        showMoreTextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textForPost.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textForPost.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            textForPost.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            textForPost.bottomAnchor.constraint(equalTo: showMoreTextButton.topAnchor),
            
            showMoreTextButton.topAnchor.constraint(equalTo: textForPost.bottomAnchor),
            showMoreTextButton.widthAnchor.constraint(equalToConstant: 150),
            showMoreTextButton.heightAnchor.constraint(equalToConstant: 30),
            showMoreTextButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10),
            showMoreTextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
        ])
    }
    
    //    MARK: - Configuring cell
    
    func configureCell(_ postText: News, isTapped: Bool) {
        textForPost.text = postText.text
        if isTapped {
            self.isPressed = false
            showMoreTextButton.setTitle(self.buttonStateName(), for: .normal)
            showMoreTextButton.isHidden = false
        } else {
            showMoreTextButton.isHidden = true
        }
    }
    
    private func buttonStateName() -> String {
        isPressed ? "Show Less": "Show More"
    }
    
}

extension NewsTableViewCellPost: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
