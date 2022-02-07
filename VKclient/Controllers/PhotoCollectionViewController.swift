//
//  PhotoCollectionViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 25.08.2021.
//

import UIKit
import RealmSwift
import SwiftUI

class PhotoViewController: UIViewController, UICollectionViewDelegateFlowLayout  {
    @IBOutlet var photoCollection: UICollectionView!
    var friendID: Int = 0
    var photosFromDB: Results<RealmPhotos>?
    var photosNotification: NotificationToken?
    var user: User?
    var arrayOfRealm = [String]() {
        didSet {
            self.photoCollection.reloadData()
        }
    }
    

    var friendsPhotos = [UIImage?]()
    var userPhotosNetwork: [String] = [] {
        didSet {
            photoCollection.reloadData()
        }
    }
    private let network = NetworkService()
    private let token = Session.instance.token
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        photoCollection.collectionViewLayout = layout
//        photosFromDBtoArray()
        loadFromDB()
    }
    
//    private func photosFromDBtoArray() {
//        guard  let photos = photosFromDB else { return }
//        for photo in photos {
//            self.arrayOfRealm.append(photo.sizes["x"]!)
//                }
//    }
    
    private func loadFromDB() {


        network.loadPhotos(token: token, ownerID: String(friendID))
         
//            guard  let photos = self.photosFromDB else { return }
//                 for photo in photos {
//                     self.arrayOfRealm.append(photo.sizes["x"]!)
//                         }
//            self.photoCollection.reloadData()
//

        photosFromDB = try! RealmService.load(typeOf: RealmPhotos.self).filter(NSPredicate(format: "ownerID == %d", friendID))

        photosNotification = photosFromDB?.observe(on: .main, { realmChange in
            switch realmChange {
            case .initial(let objects):
                if objects.count > 0 {
                    //                self.groupsfromRealm = objects
                    self.photoCollection.reloadData()
                }
                print(objects)

            case let .update(groupsRealm, deletions, insertions, modifications ):
                self.photoCollection.performBatchUpdates {
                    let delete = deletions.map {IndexPath(
                        item: $0,
                        section: 0) }
                    self.photoCollection.deleteItems(at: delete)

                    let insert = insertions.map { IndexPath(
                        item: $0,
                        section: 0) }

                    self.photoCollection.insertItems(at: insert)

                    let modify = modifications.map { IndexPath(
                        item: $0,
                        section: 0) }
                    self.photoCollection.reloadItems(at: modify)
                }

            case .error(let error):
                print(error)

            }
        })
    }
//
//  private  func toArray(_ result: Map<String, String>) -> [String] {
//        var some: [String] = []
//
//        for element in result {
//            if element.key == "x" {
//                while some.count < result.count{
//                    some.append(element.value)
//                }
//            }
//        }
//        return some
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "toExtendedPhotos",
            let dataDestination = segue.destination as? extendedPhotoViewController,
            let indexPath = photoCollection.indexPathsForSelectedItems?.first
        else { return }
        var userArray: [String] = []
        guard let userPhotos = photosFromDB else { return }
        for element in userPhotos {
            userArray.append(element.sizes["x"]!)
        }
        dataDestination.arrayOfPhotosFromDB = userArray
        dataDestination.friendID = friendID
        dataDestination.indexOfSelectedPhoto = Int(indexPath.item)
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photosFromDB?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCollectionViewCell
        //        MARK: PHOTOS FROM DB
        guard let photosFromDB = photosFromDB else { return cell }
        cell.photoCollectionCell.sd_setImage(with: URL(string: photosFromDB[indexPath.row].sizes["x"]!))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}

extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
}



