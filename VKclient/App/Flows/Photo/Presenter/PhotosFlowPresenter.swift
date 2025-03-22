//
//  PhotosFlowPresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit
import Combine
import KeychainAccess

protocol PhotosFlowViewInput: AnyObject {
    func updateTableView()
}

protocol PhotosFlowViewOutput: AnyObject {
    var realmPhotos: Results<RealmPhotos>? { get }
    func fetchData()
    func dataUpdates()
    func goNextScreen(index: IndexPath)
}

final class PhotosFlowPresenter {
    @Injected(\.photosService) var photosService: PhotosServiceProtocol
    @Injected(\.realmService) var realmService: RealmServiceProtocol
    private var cancellable = Set<AnyCancellable>()
    var friendID = try? Keychain().get("userID")
    var realmPhotos: Results<RealmPhotos>?
    var photosNotification: NotificationToken?
    var photosForExtendedController: [String] = []
    
    weak var viewInput: (UIViewController & PhotosFlowViewInput)?
    
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
                self.viewInput?.updateTableView()
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
                self.viewInput?.updateTableView()
            case let .error(error):
                print(error)
            }
        }
    }
    
    private func openExtendedPhotoView(_ indexPath: IndexPath) {
        guard let userPhotos = realmPhotos
        else { return }
        photosForExtendedController.removeAll()
        for element in userPhotos {
            photosForExtendedController.append(element.sizes["x"]!)
        }
        let viewController = ExtendedPhotoViewController(arrayOfPhotosFromDB: self.photosForExtendedController,
                                                         indexOfSelectedPhoto: Int(indexPath.item))
        self.viewInput?.navigationController?.pushViewController(viewController.self, animated: true)
    }
}

extension PhotosFlowPresenter: PhotosFlowViewOutput {
    func fetchData() {
        self.fetchDataFromNetwork()
    }
    func dataUpdates() {
        DispatchQueue.main.async {
        self.updatesFromRealm()
        }
    }
    func goNextScreen(index: IndexPath) {
        self.openExtendedPhotoView(index)
    }
}
