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
   
    let repostButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        b.setTitleColor(.black, for: .normal)
        
        return b
    }()
    
    let commentsButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "message"), for: .normal)
        b.setTitleColor(.black, for: .normal)
        
        return b
    }()
    
    let likesButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        b.tintColor = .red
        b.setTitleColor(.black, for: .normal)
        
        return b
    }()
    
    let viewsCounter: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "eye"), for: .normal)
        b.setTitleColor(.black, for: .normal)
        
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
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewsCounter.setTitle("0", for: .normal)
        self.repostButton.setTitle("0", for: .normal)
        self.commentsButton.setTitle("0", for: .normal)
        self.likesButton.setTitle("0", for: .normal)
    }
    
    //     MARK: - UI
    
    private func configureUI() {
        self.addSubviews()
        self.setupConstraints()
    }
    
    private func addSubviews() {
        self.addSubview(self.commentsButton)
        self.addSubview(self.likesButton)
        self.addSubview(self.repostButton)
        self.addSubview(self.viewsCounter)
    }
    
    private func setupConstraints() {
        
        let s = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.likesButton.topAnchor.constraint(equalTo: s.topAnchor, constant: 5),
            self.likesButton.leftAnchor.constraint(equalTo: s.leftAnchor, constant: 10),
            self.likesButton.bottomAnchor.constraint(equalTo: s.bottomAnchor, constant: 5),
            
            self.commentsButton.leftAnchor.constraint(equalTo: likesButton.rightAnchor, constant: 20),
            self.commentsButton.topAnchor.constraint(equalTo: s.topAnchor, constant: 5),
            self.commentsButton.bottomAnchor.constraint(equalTo: s.bottomAnchor, constant: 5),
            
            self.repostButton.leftAnchor.constraint(equalTo: commentsButton.rightAnchor, constant: 20),
            self.repostButton.topAnchor.constraint(equalTo: s.topAnchor, constant: 5),
            self.repostButton.bottomAnchor.constraint(equalTo: s.bottomAnchor, constant: 5),
            
            self.viewsCounter.rightAnchor.constraint(equalTo: s.rightAnchor, constant: 0),
            self.viewsCounter.topAnchor.constraint(equalTo: s.topAnchor, constant: 5),
            self.viewsCounter.bottomAnchor.constraint(equalTo: s.bottomAnchor, constant: 5)
        ])
    }
    
    func configureCell(_ data: PostNews) {
        self.viewsCounter.setTitle("\(data.views.description)", for: .normal)
        self.repostButton.setTitle("\(data.reposts)", for: .normal)
        self.commentsButton.setTitle("\(data.comments)", for: .normal)
        self.likesButton.setTitle("\(data.likes)", for: .normal)
    }
    
}
