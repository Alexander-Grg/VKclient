//
//  extendedPhotoViewController.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 9/25/21.
//

import UIKit
import SDWebImage
import RealmSwift

class extendedPhotoViewController: UIViewController {
    
    let network = NetworkService()
    let token = Session.instance.token
    var friendID = 0
    //   lazy var photosFromRealm: Results<RealmPhotos>? =
    //    try? Realm(configuration: RealmService.deleteIfMigration)
    //        .objects(RealmPhotos.self)
    //        .filter(NSPredicate(format: "ownerID == %d", friendID))
    //
    //
    //    var arrayOfRealm: [String] = []
    var indexOfSelectedPhoto = 0
    var userPhotosDB: [String] = []
//    var sortedPhotosDB: [String] = []
    var arrayOfPhotosFromDB: [String] = []
    var leftImage: UIImageView!
    var mainImage: UIImageView!
    var rightImage: UIImageView!
    var swipeToRight: UIViewPropertyAnimator!
    var swipeToLeft: UIViewPropertyAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //        loadPhotosFromNetwork()
        //        objectsFromRealm()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let gestureRecPan = UIPanGestureRecognizer(target: self, action: #selector(panSettings(_:)))
        view.addGestureRecognizer(gestureRecPan)
        imagesSettings()
        AnimationStarts()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func imagesSettings(){
        
        var leftPhotoIndex = indexOfSelectedPhoto - 1
        let mainPhotoIndex = indexOfSelectedPhoto
        var rightPhotoIndex = indexOfSelectedPhoto + 1
        
        if leftPhotoIndex < 0 {
            leftPhotoIndex = arrayOfPhotosFromDB.count - 1
            
        }
        if rightPhotoIndex > arrayOfPhotosFromDB.count - 1 {
            rightPhotoIndex = 0
        }
        view.subviews.forEach({ $0.removeFromSuperview() })
        leftImage = UIImageView()
        mainImage = UIImageView()
        rightImage = UIImageView()
        
        leftImage.contentMode = .scaleAspectFill
        mainImage.contentMode = .scaleAspectFill
        rightImage.contentMode = .scaleAspectFill
        
        view.addSubview(leftImage)
        view.addSubview(mainImage)
        view.addSubview(rightImage)
        
        leftImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        rightImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            mainImage.heightAnchor.constraint(equalTo: mainImage.widthAnchor, multiplier: 4/3),
            mainImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            leftImage.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            leftImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftImage.heightAnchor.constraint(equalTo: mainImage.heightAnchor),
            leftImage.widthAnchor.constraint(equalTo: mainImage.widthAnchor),
            
            rightImage.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            rightImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rightImage.heightAnchor.constraint(equalTo: mainImage.heightAnchor),
            rightImage.widthAnchor.constraint(equalTo: mainImage.widthAnchor),
        ])
        
      
        leftImage.sd_setImage(with: URL(string: arrayOfPhotosFromDB[leftPhotoIndex]))
        mainImage.sd_setImage(with: URL(string: arrayOfPhotosFromDB[mainPhotoIndex]))
        rightImage.sd_setImage(with: URL(string: arrayOfPhotosFromDB[rightPhotoIndex]))
        
        mainImage.layer.cornerRadius = 8
        rightImage.layer.cornerRadius = 8
        leftImage.layer.cornerRadius = 8
        
        mainImage.clipsToBounds = true
        rightImage.clipsToBounds = true
        leftImage.clipsToBounds = true
        
        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        self.mainImage.transform = scale
        self.rightImage.transform = scale
        self.leftImage.transform = scale
        
    }
    
    func AnimationStarts(){
        imagesSettings()
        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: [],
            animations: { [unowned self] in
                self.mainImage.transform = .identity
                self.rightImage.transform = .identity
                self.leftImage.transform = .identity
            })
    }
    
    @objc func panSettings(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            swipeToRight = UIViewPropertyAnimator(
                duration: 0.5,
                curve: .easeInOut,
                animations: {
                    UIView.animate(
                        withDuration: 0.01,
                        delay: 0,
                        options: [],
                        animations: { [unowned self] in
                            let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                            let translation = CGAffineTransform(translationX: self.view.bounds.maxX - 40, y: 0)
                            let transform = scale.concatenating(translation)
                            self.mainImage.transform = transform
                            self.rightImage.transform = transform
                            self.leftImage.transform = transform
                        }, completion: { [unowned self] _ in
                            self.indexOfSelectedPhoto -= 1
                            if self.indexOfSelectedPhoto < 0 {
                                self.indexOfSelectedPhoto = self.arrayOfPhotosFromDB.count - 1
                            }
                            self.AnimationStarts()
                        })
                })
            swipeToLeft = UIViewPropertyAnimator(
                duration: 0.5,
                curve: .easeInOut,
                animations: {
                    UIView.animate(
                        withDuration: 0.01,
                        delay: 0,
                        options: [],
                        animations: { [unowned self] in
                            let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                            let translation = CGAffineTransform(translationX: -self.view.bounds.maxX + 40, y: 0)
                            let transform = scale.concatenating(translation)
                            self.mainImage.transform = transform
                            self.rightImage.transform = transform
                            self.leftImage.transform = transform
                        }, completion: { [unowned self] _ in
                            self.indexOfSelectedPhoto += 1
                            if self.indexOfSelectedPhoto > self.arrayOfPhotosFromDB.count - 1 {
                                self.indexOfSelectedPhoto = 0
                            }
                            self.AnimationStarts()
                        })
                })
        case .changed:
            let translationX = recognizer.translation(in: self.view).x
            if translationX > 0 {
                swipeToRight.fractionComplete = abs(translationX)/100
            } else {
                swipeToLeft.fractionComplete = abs(translationX)/100
            }
            
        case .ended:
            swipeToRight.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            swipeToLeft.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            return
        }
    }
}
