//
//  UserProfilePresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/25.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift
import KeychainAccess
import Combine

protocol UserProfileInput {
    var userProfileView: UserProfileView { get set }
    func updatePhotoPreview(with photos: [String])
}

protocol UserProfileOutput {
    var user: UserRealm? { get }
    var friendID: String? { get }
    func viewDidLoad()
    func updatesForPhotos()
    func makeTransitionToThePhotos()
    func loadPhotosForPreview()
}

final class UserProfilePresenter {
    private var cancellable = Set<AnyCancellable>()
    @Injected(\.photosService) var photosService: PhotosServiceProtocol
    @Injected(\.realmService) var realmService: RealmServiceProtocol
    weak var viewInput: (UIViewController & UserProfileInput)?
    let user: UserRealm?
    var photosForExtendedController: [String] = []
    var index: Int?
    var friendID = try? Keychain().get("userID")
    var photosNotification: NotificationToken?
    var realmPhotos: Results<RealmPhotos>?

    init(user: UserRealm?, index: Int?) {
        self.user = user
        self.index = index
    }

    private func configureData() {
        guard let userData = user else { return }

        viewInput?.userProfileView.profileAvatar.imageView.sd_setImage(with: URL(string: userData.avatar))

        if !userData.sex.isEmpty {
            let sexText = NSMutableAttributedString(string: "Gender: ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
            let sexValue = NSAttributedString(string: userData.sex, attributes: [.font: UIFont.systemFont(ofSize: 14)])
            sexText.append(sexValue)
            viewInput?.userProfileView.sexLabel.attributedText = sexText
        }

        if !userData.birthday.isEmpty {
            let birthdayText = NSMutableAttributedString(string: "Birthday: ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
            let birthdayValue = NSAttributedString(string: userData.birthday, attributes: [.font: UIFont.systemFont(ofSize: 14)])
            birthdayText.append(birthdayValue)
            viewInput?.userProfileView.birthdayLabel.attributedText = birthdayText
        }

        if !userData.location.isEmpty {
            let cityText = NSMutableAttributedString(string: "City: ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
            let cityValue = NSAttributedString(string: userData.location, attributes: [.font: UIFont.systemFont(ofSize: 14)])
            cityText.append(cityValue)
            viewInput?.userProfileView.locationLabel.attributedText = cityText
        }

        viewInput?.userProfileView.profileName.text = userData.firstName + " " + userData.lastName
    }

    private func loadPhotosForExtendedVC() {
        guard let userPhotos = realmPhotos else { return }
        var newPhotos: [String] = []

        for element in userPhotos {
            if let urlString = element.sizes["x"] {
                newPhotos.append(urlString)
            } else {
                print("Missing photo URL for \(element)")
            }
        }
        self.photosForExtendedController = newPhotos
    }

    private func fetchDataFromNetwork() {
        photosService.requestPhotos(id: friendID ?? "")
            .decode(type: PhotosResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.savingToRealm(value.response.items)
                self.loadDataFromRealm()
            }
            )
            .store(in: &cancellable)
    }

    private func savingToRealm(_ value: [PhotosObject]) {
        do {
            let realm = value.map { RealmPhotos(photos: $0)}
            try self.realmService.save(items: realm, configuration: .defaultConfiguration, update: .modified)
        } catch {
            print("Saving to Realm failed")
        }
    }

    private func loadDataFromRealm() {
        guard let intFriendID = Int(friendID ?? "") else { return }
        do {
            self.realmPhotos = try self.realmService.get(type: RealmPhotos.self, configuration: .defaultConfiguration).filter(NSPredicate(format: "ownerID == %d", intFriendID))
            self.loadPhotosForExtendedVC()
            DispatchQueue.main.async {
                self.loadPhotosForPreview()
            }
        } catch {
            print("Loading from Realm error")
        }
    }

    private func updatesFromRealm() {
        self.photosNotification = realmPhotos?.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial:
                break
            case .update:
                self.loadDataFromRealm()
            case let .error(error):
                print(error)
            }
        }
    }

    private func transitionToThePhotoAlbum() {
        let viewController = PhotosFlowBuilder.build()
        self.viewInput?.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UserProfilePresenter: UserProfileOutput {
    func viewDidLoad() {
        self.configureData()
        self.fetchDataFromNetwork()
    }

    func updatesForPhotos() {
        self.updatesFromRealm()
    }

    func makeTransitionToThePhotos() {
        self.transitionToThePhotoAlbum()
    }

    func loadPhotosForPreview() {
         guard let viewInput = viewInput else { return }
         let previewImages = Array(photosForExtendedController.prefix(3))
         DispatchQueue.main.async {
             viewInput.updatePhotoPreview(with: previewImages)
         }
     }
}
