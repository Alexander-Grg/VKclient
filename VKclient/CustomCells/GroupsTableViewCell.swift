//
//  GroupsTableViewCell.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 16.01.2022.
//

import UIKit
import SDWebImage

class GroupsTableViewCell: UITableViewCell {
    
    //    MARK: - Properties
    
    private(set) lazy var avatarView: AvatarView = {
        let a = AvatarView()
        a.translatesAutoresizingMaskIntoConstraints = false
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        a.addGestureRecognizer(recognizer)
        a.isUserInteractionEnabled = true

        return a
    }()
    
    private(set) lazy var labelGroup: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 17.0)
        l.textColor = .black
        l.textAlignment = .center
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 2
        
        return l
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
        self.contentView.addSubview(self.avatarView)
        self.contentView.addSubview(self.labelGroup)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            self.avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            self.avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            self.avatarView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            self.avatarView.rightAnchor.constraint(equalTo: labelGroup.leftAnchor),
            self.avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor, multiplier: 1.0),
            
            self.labelGroup.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.labelGroup.leftAnchor.constraint(equalTo: avatarView.rightAnchor, constant: 10),
            self.labelGroup.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10)
            
            
        ])
    }
    
    @objc private func onTap() {
        avatarAnimation()
    }
    
    @objc private func avatarAnimation() {
        avatarView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 1.6,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.2,
                       options: .curveEaseOut,
                       animations: {
            self.avatarView.transform = CGAffineTransform(scaleX: 1, y: 1)}
                       ,completion: nil)
        
    }
    
    func configureCell(groups: GroupsRealm) {
        guard let url = URL(string: groups.photo) else { return }
        avatarView.imageView.sd_setImage(with: url)
        labelGroup.text = groups.name
    }
}

extension GroupsTableViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}

