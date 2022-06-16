//
//  PhotoCollectionViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 25.08.2021.
//

import UIKit
import RealmSwift

class PhotoViewController : UIViewController {
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    private enum LayoutConstant {
        static let spacing: CGFloat = 16.0
        static let itemHeight: CGFloat = 300.0
    }
    
    var friendID: Int = Session.instance.friendID
    var photosFromDB: Results<RealmPhotos>?
    var photosNotification: NotificationToken?
    var photosForExtendedController: [String] = []
    var user: User?
    var arrayOfRealm = [String]() {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        setupViews()
        setupLayouts()
        updatesFromRealm()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let photoRequest = GetPhotos(constructorPath: "photos.get",
                                     queryItems: [
                                        URLQueryItem(
                                            name: "rev",
                                            value: "1"),
                                        URLQueryItem(
                                            name: "album_id",
                                            value: "profile"),
                                        URLQueryItem(
                                            name: "offset",
                                            value: "0"),
                                        URLQueryItem(
                                            name: "photo_sizes",
                                            value: "0"),
                                        URLQueryItem(
                                            name: "owner_id",
                                            value: String(friendID))
                                     ])
        
        photoRequest.request() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                try? RealmService.save(items: photos)
                self.collectionView.reloadData()
            case .failure:
                print("Data has already been saved to Realm")
            }
        }
    }
    
    
    private func updatesFromRealm() {
        
        photosFromDB = try! RealmService.load(typeOf: RealmPhotos.self).filter(NSPredicate(format: "ownerID == %d", friendID))
        
        photosNotification = photosFromDB?.observe(on: .main, { realmChange in
            switch realmChange {
            case .initial(let objects):
                if objects.count > 0 {
                    //                self.groupsfromRealm = objects
                    self.collectionView.reloadData()
                }
                print(objects)
                
            case let .update(_, deletions, insertions, modifications ):
                self.collectionView.performBatchUpdates {
                    let delete = deletions.map {IndexPath(
                        item: $0,
                        section: 0) }
                    self.collectionView.deleteItems(at: delete)
                    
                    let insert = insertions.map { IndexPath(
                        item: $0,
                        section: 0) }
                    
                    self.collectionView.insertItems(at: insert)
                    
                    let modify = modifications.map { IndexPath(
                        item: $0,
                        section: 0) }
                    self.collectionView.reloadItems(at: modify)
                }
                
            case .error(let error):
                print(error)
                
            }
        })
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
    }
    
    private func setupLayouts() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout constraints for `collectionView`
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photosFromDB?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.identifier, for: indexPath) as! PhotosCollectionViewCell
        
        guard let photosFromDB = photosFromDB else { return cell }
        cell.profileImageView.sd_setImage(with: URL(string: photosFromDB[indexPath.row].sizes["x"]!))
        
        return cell
    }
    
}

extension PhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let userPhotos = photosFromDB
                
        else { return }
        
        for element in userPhotos {
            photosForExtendedController.append(element.sizes["x"]!)
        }
        let VC = extendedPhotoViewController(arrayOfPhotosFromDB: self.photosForExtendedController, indexOfSelectedPhoto: Int(indexPath.item))
        self.navigationController?.pushViewController(VC.self, animated: true)
        
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = itemWidth(for: view.frame.width, spacing: LayoutConstant.spacing)
        
        return CGSize(width: width, height: LayoutConstant.itemHeight)
    }
    
    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 2
        
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        
        return floor(finalWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstant.spacing, left: LayoutConstant.spacing, bottom: LayoutConstant.spacing, right: LayoutConstant.spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }
}




