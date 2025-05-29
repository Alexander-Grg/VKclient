//
//  UserProfileViewController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/25.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

final class UserProfileViewController: UIViewController {
    private let presenter: UserProfileOutput
    private let photoPreviewView = PhotoPreviewView()
    var userProfileView = UserProfileView()
    var feedViewController: FeedTableViewController?

    private var titleLabel: UILabel?
    private var expandButton: UIButton?

    init(presenter: UserProfileOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        configureUI()
        presenter.loadPhotosForPreview()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.updatesForPhotos()
    }

    private func configureUI() {
        view.backgroundColor = .white
        setupUserProfileView()
        setupPhotoPreviewView()
        setupFeedSectionHeader()
        setupEmbeddedFeed()
    }

    private func setupUserProfileView() {
        view.addSubview(userProfileView)
        userProfileView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            userProfileView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            userProfileView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            userProfileView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            userProfileView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setupPhotoPreviewView() {
        view.addSubview(photoPreviewView)
        photoPreviewView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            photoPreviewView.topAnchor.constraint(equalTo: userProfileView.bottomAnchor, constant: 20),
            photoPreviewView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            photoPreviewView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            photoPreviewView.heightAnchor.constraint(equalToConstant: 100)
        ])

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pressPhotoHandler))
        photoPreviewView.addGestureRecognizer(gestureRecognizer)
    }

    private func setupFeedSectionHeader() {
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.distribution = .equalSpacing
        headerStack.spacing = 8
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        let title = UILabel()
        title.text = "User's posts"
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
            headerStack.topAnchor.constraint(equalTo: photoPreviewView.bottomAnchor, constant: 20),
            headerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    private func setupEmbeddedFeed() {
        let feedVC = FeedFlowBuilder.buildUserWall(id: presenter.friendID ?? "")
        guard let feedTVC = feedVC as? FeedTableViewController else { return }
        self.feedViewController = feedTVC

        addChild(feedTVC)
        view.addSubview(feedTVC.view)
        feedTVC.view.translatesAutoresizingMaskIntoConstraints = false

        guard let titleLabel = self.titleLabel else { return }

        NSLayoutConstraint.activate([
            feedTVC.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            feedTVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            feedTVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            feedTVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        feedTVC.didMove(toParent: self)
    }

    func updatePhotoPreview(with photos: [String]) {
        photoPreviewView.images = Array(photos.prefix(3))
    }

    @objc private func pressPhotoHandler() {
        presenter.makeTransitionToThePhotos()
    }

    @objc private func presentFeedSheet() {
        let sheetFeedVC = FeedFlowBuilder.buildUserWall(id: presenter.friendID ?? "")

        if let sheet = sheetFeedVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        }

        present(sheetFeedVC, animated: true)
    }
}

extension UserProfileViewController: UserProfileInput {}
