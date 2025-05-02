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
        self.configureUI()
        presenter.loadPhotosForPreview()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.updatesForPhotos()
    }

    private func configureUI() {
        self.view.backgroundColor = .white
        self.setupUserProfileView()
        self.setupPhotoPreviewView()
    }

    private func setupUserProfileView() {
        self.view.addSubview(userProfileView)
        self.userProfileView.translatesAutoresizingMaskIntoConstraints = false
        let safeAreaInsets = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.userProfileView.topAnchor.constraint(equalTo: safeAreaInsets.topAnchor),
            self.userProfileView.leadingAnchor.constraint(equalTo: safeAreaInsets.leadingAnchor),
            self.userProfileView.trailingAnchor.constraint(equalTo: safeAreaInsets.trailingAnchor),
            self.userProfileView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func setupPhotoPreviewView() {
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

    func updatePhotoPreview(with photos: [String]) {
        photoPreviewView.images = Array(photos.prefix(3))
    }

    @objc func pressPhotoHandler() {
        presenter.makeTransitionToThePhotos()
    }
}

extension UserProfileViewController: UserProfileInput {

}
