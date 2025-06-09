//
//  GroupDetailViewController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-05.
//  Copyright © 2024–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

enum GroupDetailType {
    case groupSearch
    case groupMenu
}

final class GroupDetailViewController: UIViewController {

    var groupsDetailView = GroupDetailView()
    var feedViewController: FeedTableViewController?

    private let presenter: GroupsDetailOutput
    private var titleLabel: UILabel?
    private var expandButton: UIButton?
    private var emptyFeedStateView: UIView?

    init(presenter: GroupsDetailOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        groupsDetailView.groupDetaildelegate = self
        presenter.viewDidLoad()
        setupGroupProfileView()
        setupFeedSectionHeader()
        setupEmptyStateView()
        setupEmbeddedFeed()
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

    private func setupFeedSectionHeader() {
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.distribution = .equalSpacing
        headerStack.spacing = 8
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        let title = UILabel()
        title.text = "Group's posts"
        title.font = .systemFont(ofSize: 16, weight: .heavy)
        self.titleLabel = title

        let button = UIButton(type: .system)
        button.setTitle("Expand", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(presentFeedSheet), for: .touchUpInside)
        self.expandButton = button

        headerStack.addArrangedSubview(title)
        headerStack.addArrangedSubview(button)
        view.addSubview(headerStack)

        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: groupsDetailView.bottomAnchor, constant: 20),
            headerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    private func setupEmptyStateView() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true

        let label = UILabel()
        presenter.isMember ? (label.text = "You're a group member, access the group from the groups menu to see the feed") : (label.text = "Join the group to view posts")
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])

        self.view.addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: titleLabel?.bottomAnchor ?? groupsDetailView.bottomAnchor, constant: 20),
            view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])

        self.emptyFeedStateView = view
    }

    private func setupEmbeddedFeed() {
        guard presenter.type == .groupMenu else {
            emptyFeedStateView?.isHidden = false
            return
        }

        emptyFeedStateView?.isHidden = true

        let communityID = presenter.group?.id ?? 0
        let feedVC = FeedFlowBuilder.buildGroupWall(id: String(communityID))
        addChild(feedVC)
        view.addSubview(feedVC.view)
        feedViewController = feedVC as? FeedTableViewController

        feedVC.view.translatesAutoresizingMaskIntoConstraints = false
        guard let titleLabel = self.titleLabel else { return }

        NSLayoutConstraint.activate([
            feedVC.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            feedVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            feedVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            feedVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        feedVC.didMove(toParent: self)
    }

    @objc private func presentFeedSheet() {
        let communityID = presenter.group?.id ?? 0

        guard let table = feedViewController?.tableView,
              let topIndexPath = table.indexPathsForVisibleRows?.first
        else { return }

        let sheetVC = FeedFlowBuilder.buildGroupWall(id: String(communityID))

        if let sheetTVC = sheetVC as? FeedTableViewController {
            sheetTVC.restoreScroll(to: topIndexPath)
        }

        let nav = UINavigationController(rootViewController: sheetVC)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        }

        present(nav, animated: true)
    }
}

extension GroupDetailViewController: GroupsDetailInput {}

extension GroupDetailViewController: GroupDetailDelegate {
    func didGroupButtonTap(_ isTapped: Bool) {
        let updateUI: () -> Void = { [weak self] in
            guard let self = self else { return }

            self.groupsDetailView.setupJoinLeaveButton(isJoined: self.presenter.isMember)

            if let feedVC = self.feedViewController {
                feedVC.willMove(toParent: nil)
                feedVC.view.removeFromSuperview()
                feedVC.removeFromParent()
                self.feedViewController = nil
            }

            self.emptyFeedStateView?.removeFromSuperview()
            self.emptyFeedStateView = nil

            self.setupEmptyStateView()
            self.setupEmbeddedFeed()
        }

        if isTapped && presenter.isMember {
            presenter.leaveGroup(completion: updateUI)
        } else if isTapped && !presenter.isMember {
            presenter.joinGroup(completion: updateUI)
        }
    }
}
