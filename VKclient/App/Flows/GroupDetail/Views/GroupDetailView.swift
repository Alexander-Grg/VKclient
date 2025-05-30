//
//  GroupDetailView.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-05.
//  Copyright © 2024–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

protocol GroupDetailDelegate: AnyObject {
    func didGroupButtonTap(_ isTapped: Bool)
}

final class GroupDetailView: UIView {

    weak var groupDetaildelegate: GroupDetailDelegate?

    private(set) lazy var groupImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        
        return image
    }()
    
    private(set) lazy var groupNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.textColor = .black
        
        return label
    }()
    
    private(set) lazy var groupStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    private(set) lazy var isDeletedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    private(set) lazy var isMemberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    private(set) lazy var groupCoverImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private(set) lazy var joinGroupButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            button.configuration = .bordered()
        } else {
            // Fallback on earlier versions
        }
        button.addTarget(self, action: #selector(groupButtonTap), for: .touchUpInside)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        self.addSubviews()
        self.setupConstraints()
    }
    
    private func addSubviews() {
        self.addSubview(groupImage)
        self.addSubview(groupNameLabel)
        self.addSubview(groupStatusLabel)
        self.addSubview(isMemberLabel)
        self.addSubview(joinGroupButton)
        self.addSubview(isDeletedLabel)
    }
    
    private func setupConstraints() {
        
        let s = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            groupImage.topAnchor.constraint(equalTo: s.topAnchor, constant: 20),
            groupImage.centerXAnchor.constraint(equalTo: s.centerXAnchor),
            groupImage.heightAnchor.constraint(equalToConstant: 100),
            groupImage.widthAnchor.constraint(equalToConstant: 100),
            
            groupNameLabel.topAnchor.constraint(equalTo: groupImage.bottomAnchor),
            groupNameLabel.leftAnchor.constraint(equalTo: s.leftAnchor),
            groupNameLabel.rightAnchor.constraint(equalTo: s.rightAnchor),
            groupNameLabel.centerXAnchor.constraint(equalTo: groupImage.centerXAnchor),
            groupNameLabel.heightAnchor.constraint(equalToConstant: 25),
            groupNameLabel.widthAnchor.constraint(equalToConstant: 100),
            
            groupStatusLabel.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 10),
            groupStatusLabel.leftAnchor.constraint(equalTo: s.leftAnchor),
            groupStatusLabel.rightAnchor.constraint(equalTo: s.rightAnchor),
            
            isMemberLabel.topAnchor.constraint(equalTo: groupStatusLabel.bottomAnchor, constant: 10),
            isMemberLabel.leftAnchor.constraint(equalTo: s.leftAnchor),
            isMemberLabel.rightAnchor.constraint(equalTo: s.rightAnchor),
            
            joinGroupButton.topAnchor.constraint(equalTo: isMemberLabel.bottomAnchor, constant: 20),
            joinGroupButton.centerXAnchor.constraint(equalTo: s.centerXAnchor),
            joinGroupButton.heightAnchor.constraint(equalToConstant: 30),
            joinGroupButton.widthAnchor.constraint(equalToConstant: 200),

            isDeletedLabel.topAnchor.constraint(equalTo: joinGroupButton.bottomAnchor, constant: 10),
            isDeletedLabel.leftAnchor.constraint(equalTo: s.leftAnchor),
            isDeletedLabel.rightAnchor.constraint(equalTo: s.rightAnchor)
        ])
    }
    
    @objc func groupButtonTap() {
        groupDetaildelegate?.didGroupButtonTap(true)
    }

    func setupJoinLeaveButton(isJoined: Bool) {
        joinGroupButton.setTitle(isJoined ? "Leave group" : "Join group", for: .normal)
        joinGroupButton.setTitleColor( isJoined ? UIColor.red :  UIColor.blue, for: .normal)
    }
}
