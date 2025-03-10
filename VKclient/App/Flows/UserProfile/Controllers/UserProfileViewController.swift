//
//  UserProfileViewController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/25.
//

import UIKit

class UserProfileViewController: UIViewController {
    private let presenter: UserProfileOutput
    lazy var userProfileView = UserProfileView()
    private var photosViewController: ExtendedPhotoViewController?

    init(presenter: UserProfileOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        self.view = userProfileView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        self.configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.updatesForPhotos()
    }

    private func configureUI() {
        self.view.backgroundColor = .white
        self.setupExtendedViewController()
        self.setupConstraints()
    }

    private func setupExtendedViewController() {
        guard let userProfilePresenter = presenter as? UserProfilePresenter else { return }

        if let existingPhotosVC = self.photosViewController {
            existingPhotosVC.willMove(toParent: nil)
            existingPhotosVC.view.removeFromSuperview()
            existingPhotosVC.removeFromParent()
        }

        let extendedVC = ExtendedPhotoViewController(
            arrayOfPhotosFromDB: userProfilePresenter.photosForExtendedController,
            indexOfSelectedPhoto: userProfilePresenter.index ?? 0
        )

        addChild(extendedVC)
        view.addSubview(extendedVC.view)
        extendedVC.didMove(toParent: self)
        extendedVC.view.translatesAutoresizingMaskIntoConstraints = false

        self.photosViewController = extendedVC
    }
    private func setupConstraints() {

        let safeAreaInsets = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.userProfileView.topAnchor.constraint(equalTo: safeAreaInsets.topAnchor),
            self.userProfileView.leadingAnchor.constraint(equalTo: safeAreaInsets.leadingAnchor),
            self.userProfileView.trailingAnchor.constraint(equalTo: safeAreaInsets.trailingAnchor),
            self.userProfileView.heightAnchor.constraint(equalToConstant: 300)
        ])

        if let photosView = self.photosViewController?.view {
            NSLayoutConstraint.activate([
                photosView.topAnchor.constraint(equalTo: self.userProfileView.bottomAnchor),
                photosView.leadingAnchor.constraint(equalTo: safeAreaInsets.leadingAnchor),
                photosView.trailingAnchor.constraint(equalTo: safeAreaInsets.trailingAnchor),
                photosView.bottomAnchor.constraint(equalTo: safeAreaInsets.bottomAnchor),
                photosView.widthAnchor.constraint(equalToConstant: 150)
            ])
        }
    }
}

//TODO: To fix the photosViewController, not displaying.

extension UserProfileViewController: UserProfileInput {

}
