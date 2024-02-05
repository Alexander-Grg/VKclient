//
//  GroupDetailView.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-05.
//

import UIKit

final class GroupDetailView: UIView {

//    MARK: Properties

    private (set) lazy var groupImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true

        return image
    }()

    private (set) lazy var groupNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.textColor = .black

        return label
    }()

    private (set) lazy var groupStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black

        return label
    }()

    private (set) lazy var isDeletedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black

        return label
    }()

    private (set) lazy var isMemberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black

        return label
    }()

    private (set) lazy var groupCoverImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()

//    MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //    MARK: Methods

    private func configureUI() {
        self.addSubviews()
        self.setupConstraints()
    }

    private func addSubviews() {
        self.addSubview(groupCoverImage)
        self.addSubview(groupImage)
        self.addSubview(groupNameLabel)
        self.addSubview(groupStatusLabel)
        self.addSubview(isDeletedLabel)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            


        ])
    }
}
