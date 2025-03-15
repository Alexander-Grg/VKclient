//
//  UserProfileViewController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/25.
//

import UIKit

final class UserProfileViewController: UIViewController {
    private let presenter: UserProfileOutput
    private var photosViewController: ExtendedPhotoViewController?
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.updatesForPhotos()
    }

    private func configureUI() {
        self.view.backgroundColor = .white
        self.setupUserProfileView()
        self.setupExtendedViewController()
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

    func setupExtendedViewController() {
        guard let userProfilePresenter = presenter as? UserProfilePresenter else { return }
        let safeAreaInsets = self.view.safeAreaLayoutGuide
         let extendedVC = ExtendedPhotoViewController(
            arrayOfPhotosFromDB: userProfilePresenter.photosForExtendedController,
             indexOfSelectedPhoto: userProfilePresenter.index ?? 0
         )

         addChild(extendedVC)
         view.addSubview(extendedVC.view)
         extendedVC.didMove(toParent: self)
         extendedVC.view.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                extendedVC.view.topAnchor.constraint(equalTo: self.userProfileView.bottomAnchor),
                extendedVC.view.leadingAnchor.constraint(equalTo: safeAreaInsets.leadingAnchor),
                extendedVC.view.trailingAnchor.constraint(equalTo: safeAreaInsets.trailingAnchor),
                extendedVC.view.bottomAnchor.constraint(equalTo: safeAreaInsets.bottomAnchor),
                extendedVC.view.heightAnchor.constraint(equalToConstant: 200)
            ])
         self.photosViewController = extendedVC
   }
}

//TODO: To fix the photosViewController, not displaying.

extension UserProfileViewController: UserProfileInput {

}
