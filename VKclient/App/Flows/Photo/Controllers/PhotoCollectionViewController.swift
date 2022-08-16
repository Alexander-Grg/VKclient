//
//  PhotoCollectionViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 25.08.2021.
//

import UIKit
import RealmSwift
import Combine

class PhotoViewController: UIViewController {

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

    private var cancellable = Set<AnyCancellable>()
    private let photosService = PhotosService()
    
    var friendID: Int = Session.instance.friendID
    var realmPhotos: Results<RealmPhotos>?
    var photosNotification: NotificationToken?
    var photosForExtendedController: [String] = []
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupLayouts()
//        updatesFromRealm()
        requestPhotosFromNetwork()

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestPhotosFromNetwork()
    }
    
    private func requestPhotosFromNetwork() {
        photosService.requestPhotos(id: String(friendID))
            .decode(type: PhotosResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] error in
                self?.realmPhotos = nil
                print(error)
            }, receiveValue: { [weak self] value in
                self?.savingDataToRealm(value.response.items)
                self?.updatesFromRealm()
            }
            )
            .store(in: &cancellable)
    }
    
    private func savingDataToRealm(_ data: [PhotosObject]) {
          do {
              let dataRealm = data.map {RealmPhotos(photos: $0)}
              try? RealmService.save(items: dataRealm)
          }
      }
    
//    private func updatesFromRealm() {
//        realmPhotos = try? RealmService.get(type: RealmPhotos.self)
////            .filter(NSPredicate(format: "ownerID == %d", friendID))
//
//           photosNotification = realmPhotos?.observe { [weak self] changes in
//               guard let self = self else { return }
//               switch changes {
//               case .initial:
//                   break
//               case .update:
//                   self.collectionView.reloadData()
//               case let .error(error):
//                   print(error)
//               }
//           }
//       }
    private func updatesFromRealm() {
        do {
        realmPhotos = try RealmService.load(
            typeOf: RealmPhotos.self)
        .filter(NSPredicate(format: "ownerID == %d", friendID))
    } catch {
print("Realm Error")
    }
        photosNotification = realmPhotos?.observe(on: .main, { realmChange in
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
        collectionView.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier)
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
        realmPhotos?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotosCollectionViewCell.identifier,
            for: indexPath) as? PhotosCollectionViewCell,
              let photosFromDB = realmPhotos else { return UICollectionViewCell()}
        cell.profileImageView.sd_setImage(with: URL(string: photosFromDB[indexPath.row].sizes["x"]!))
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let userPhotos = realmPhotos
        else { return }
        for element in userPhotos {
            photosForExtendedController.append(element.sizes["x"]!)
        }
        let viewController = ExtendedPhotoViewController(arrayOfPhotosFromDB: self.photosForExtendedController,
                                             indexOfSelectedPhoto: Int(indexPath.item))
        self.navigationController?.pushViewController(viewController.self, animated: true)

    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = itemWidth(for: view.frame.width, spacing: LayoutConstant.spacing)

        return CGSize(width: width, height: LayoutConstant.itemHeight)
    }

    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 2

        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow

        return floor(finalWidth)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int)
    -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstant.spacing,
                            left: LayoutConstant.spacing,
                            bottom: LayoutConstant.spacing,
                            right: LayoutConstant.spacing)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int)
    -> CGFloat {
        return LayoutConstant.spacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int)
    -> CGFloat {
        return LayoutConstant.spacing
    }
}
