//
//  GroupDetailViewController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-05.
//  Copyright © 2024–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

final class GroupDetailViewController: UIViewController {

    var groupsDetailView = GroupDetailView()
    var feedViewController: FeedTableViewController?
    
    private let presenter: GroupsDetailOutput

    init(presenter: GroupsDetailOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        groupsDetailView.groupDetaildelegate = self
        presenter.viewDidLoad()
        setupGroupProfileView()
        setupFeedViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupsDetailView.setupJoinLeaveButton(isJoined: presenter.isMember)
    }

    private func setupGroupProfileView() {
        self.view.addSubview(groupsDetailView)
        self.groupsDetailView.translatesAutoresizingMaskIntoConstraints = false
        let safeAreaInsets = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.groupsDetailView.topAnchor.constraint(equalTo: safeAreaInsets.topAnchor),
            self.groupsDetailView.leadingAnchor.constraint(equalTo: safeAreaInsets.leadingAnchor),
            self.groupsDetailView.trailingAnchor.constraint(equalTo: safeAreaInsets.trailingAnchor),
            self.groupsDetailView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func setupFeedViewController() {
        let titleLabel = UILabel()
        titleLabel.text = "Posts"
        titleLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let communityID = presenter.group?.id ?? 0
//        TODO: Pass a source ID of the post
        let feedVC = FeedFlowBuilder.buildGroupWall(id: String(communityID), type: .none)
        addChild(feedVC)
        view.addSubview(titleLabel)
        view.addSubview(feedVC.view)
        feedViewController = feedVC as? FeedTableViewController

        feedVC.view.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: groupsDetailView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            feedVC.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            feedVC.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            feedVC.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            feedVC.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

        feedVC.didMove(toParent: self)
    }
}

extension GroupDetailViewController: GroupsDetailInput {
}

extension GroupDetailViewController: GroupDetailDelegate {
    func didGroupButtonTap(_ isTapped: Bool) {
        if isTapped && presenter.isMember == true {
            presenter.leaveGroup()
        } else if isTapped && presenter.isMember == false {
            presenter.joinGroup()
        }
    }
}
