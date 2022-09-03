//
//  PhotosFlowPresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//

import Foundation
import RealmSwift
import UIKit
import Combine

protocol PhotosFlowViewInput {
    func updateTableView()
}

protocol PhotosFlowViewOutput {
    var realmPhotos: Results<RealmPhotos>? { get }
    func fetchData()
    func dataUpdates()
    func goNextScreen(index: IndexPath)
}

final class PhotosFlowPresenter {
    
    private var cancellable = Set<AnyCancellable>()
    private let photosService = PhotosService()
    var friendID = Session.instance.friendID
    var realmPhotos: Results<RealmPhotos>?
    var photosNotification: NotificationToken?
    var photosForExtendedController: [String] = []
    
    weak var viewInput: (UIViewController & PhotosFlowViewInput)?
    
    private func fetchDataFromNetwork() {
        photosService.requestPhotos(id: String(friendID))
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
            try RealmService.save(items: realm)
        } catch {
            print("Saving to Realm failed")
        }
    }
    
    private func loadDataFromRealm() {
        do {
            self.realmPhotos = try RealmService.get(type: RealmPhotos.self).filter(NSPredicate(format: "ownerID == %d", friendID))
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
        self.updatesFromRealm()
    }
    func goNextScreen(index: IndexPath) {
        self.openExtendedPhotoView(index)
    }
}