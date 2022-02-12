//
//  NewsFooterSection.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 10.11.2021.
//

import UIKit

class NewsFooterSection: UITableViewCell {
    
    //    MARK: - Properties
    
    static let reuseIdentifier = "NewsFooter"
    var repostButton = UIButton()
    var commentsButton = UIButton()
    var likesButton = UIButton()
    var viewsCounter = UIButton()
    var isLiked: Bool = false
    
    var likesCount: Int = 0 {
        didSet {
            likesButton.setTitle("\(self.likesCount)", for: .normal)
            UIView.transition(with: self.likesButton,
                              duration: 0.2,
                              options: [.transitionFlipFromBottom]) {
                self.likesButton.setTitle("\(self.likesCount)", for: .normal)
            }
            let image = self.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            let textColor = self.isLiked ? UIColor.red : UIColor.secondaryLabel
            self.likesButton.setImage(image, for: .normal)
            self.likesButton.setTitleColor(textColor, for: .normal)
        }
    }
    
    
    
    //    MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewsCounter.setTitle("0", for: .normal)
        repostButton.setTitle("0", for: .normal)
        commentsButton.setTitle("0", for: .normal)
    }
    
    //     MARK: - UI
    
    private func configureUI() {
        self.addRepostButton()
        self.addCommentsButton()
        self.addLikesButton()
        self.addViewsCounter()
        self.setupConstraints()
        
    }
    
    private func addRepostButton() {
        self.repostButton.translatesAutoresizingMaskIntoConstraints = false
        self.repostButton.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        self.repostButton.setTitleColor(.black, for: .normal)
        self.addSubview(self.repostButton)
    }
    
    private func addCommentsButton() {
        self.commentsButton.translatesAutoresizingMaskIntoConstraints = false
        self.commentsButton.setImage(UIImage(systemName: "message"), for: .normal)
        self.commentsButton.setTitleColor(.black, for: .normal)
        self.addSubview(self.commentsButton)
    }
    
    private func addLikesButton() {
        self.likesButton.translatesAutoresizingMaskIntoConstraints = false
        self.likesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        self.likesButton.tintColor = .red
        self.likesButton.addTarget(self, action: #selector(likeButtonHadler), for: .touchUpInside)
        self.likesButton.setTitle("\(likesCount)", for: .selected)
        self.addSubview(self.likesButton)
        
    }
    
    @objc func likeButtonHadler(_ sender: UIButton) {
        isLiked.toggle()
        isLiked ? self.likesCount += 1 : self.likesCount > 0 ? self.likesCount -= 1 : nil
    }

    
    private func addViewsCounter() {
        self.viewsCounter.translatesAutoresizingMaskIntoConstraints = false
        self.viewsCounter.setImage(UIImage(systemName: "eye"), for: .normal)
        self.viewsCounter.setTitleColor(.black, for: .normal)
        self.addSubview(self.viewsCounter)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.likesButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            self.likesButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10),
            self.likesButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 5),
            
            self.commentsButton.leftAnchor.constraint(equalTo: likesButton.rightAnchor, constant: 10),
            self.commentsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            self.commentsButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 5),
            
            self.repostButton.leftAnchor.constraint(equalTo: commentsButton.rightAnchor, constant: 10),
            self.repostButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            self.repostButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 5),
            
            self.viewsCounter.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: 0),
            self.viewsCounter.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            self.viewsCounter.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 5)
        ])
    }
    
    func configureCell(_ data: PostNews) {
        self.viewsCounter.setTitle("\(data.views.description)", for: .normal)
        self.repostButton.setTitle("\(data.reposts)", for: .normal)
        self.commentsButton.setTitle("\(data.comments)", for: .normal)
       
    }
    
}
