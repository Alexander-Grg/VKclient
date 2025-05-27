//
//  UserProfileView.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/25.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

final class UserProfileView: UIView {
    private(set) lazy var profileAvatar: AvatarView = {
        let avatar = AvatarView()

        return avatar
    }()

    private(set) lazy var profileName: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 17, weight: .medium)

        return name
    }()

    private(set) lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.font = .systemFont(ofSize: 14, weight: .regular)

        return locationLabel
    }()

    private(set) lazy var sexLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)

        return label
    }()

    private(set) lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)

        return label
    }()

    private(set) lazy var albumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.text = "User's photos"
        return label
    }()



    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tintColor = .yellow
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        backgroundColor = .white
        addSubviews()
        setupConstraints()
    }

    func addSubviews() {
        addSubview(self.profileAvatar)
        addSubview(self.profileName)
        addSubview(self.locationLabel)
        addSubview(self.sexLabel)
        addSubview(self.birthdayLabel)
        addSubview(self.albumLabel)
    }

    func setupConstraints() {
        self.profileAvatar.translatesAutoresizingMaskIntoConstraints = false
        self.profileName.translatesAutoresizingMaskIntoConstraints = false
        self.locationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sexLabel.translatesAutoresizingMaskIntoConstraints = false
        self.birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.albumLabel.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = self.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.profileAvatar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            self.profileAvatar.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.profileAvatar.widthAnchor.constraint(equalToConstant: 100),
            self.profileAvatar.heightAnchor.constraint(equalToConstant: 100),

            self.profileName.topAnchor.constraint(equalTo: self.profileAvatar.bottomAnchor, constant: 5),
            self.profileName.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            self.locationLabel.topAnchor.constraint(equalTo: self.profileName.bottomAnchor, constant: 5),
            self.locationLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            self.sexLabel.topAnchor.constraint(equalTo: self.locationLabel.bottomAnchor, constant: 5),
            self.sexLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            self.birthdayLabel.topAnchor.constraint(equalTo: self.sexLabel.bottomAnchor, constant: 5),
            self.birthdayLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            self.albumLabel.topAnchor.constraint(equalTo: self.birthdayLabel.bottomAnchor, constant: 10),
            self.albumLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)

        ])
    }
}
