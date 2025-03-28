//
//  extendedPhotoViewController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/25/21.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift
import KeychainAccess

final class ExtendedPhotoViewController: UIViewController {
    var indexOfSelectedPhoto: Int
    var arrayOfPhotosFromDB: [String]
    var leftImage: UIImageView!
    var mainImage: UIImageView!
    var rightImage: UIImageView!
    var numberOfPhotosLabel: UILabel!
    var swipeToRight: UIViewPropertyAnimator!
    var swipeToLeft: UIViewPropertyAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    init(arrayOfPhotosFromDB: [String], indexOfSelectedPhoto: Int ) {
        self.arrayOfPhotosFromDB = arrayOfPhotosFromDB
        self.indexOfSelectedPhoto = indexOfSelectedPhoto
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let gestureRecPan = UIPanGestureRecognizer(target: self, action: #selector(panSettings(_:)))
        view.addGestureRecognizer(gestureRecPan)
        imagesSettings()
        animationStarts()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.subviews.forEach({ $0.removeFromSuperview() })
        arrayOfPhotosFromDB.removeAll()
        indexOfSelectedPhoto = 0
    }

    func imagesSettings() {
        guard !arrayOfPhotosFromDB.isEmpty else { return }

        var leftPhotoIndex = indexOfSelectedPhoto - 1
        let mainPhotoIndex = indexOfSelectedPhoto
        var rightPhotoIndex = indexOfSelectedPhoto + 1

        if leftPhotoIndex < 0, !arrayOfPhotosFromDB.isEmpty {
            leftPhotoIndex = arrayOfPhotosFromDB.count - 1

        }
        if rightPhotoIndex > arrayOfPhotosFromDB.count - 1, !arrayOfPhotosFromDB.isEmpty {
            rightPhotoIndex = 0
        }
        view.subviews.forEach({ $0.removeFromSuperview() })
        leftImage = UIImageView()
        mainImage = UIImageView()
        rightImage = UIImageView()

        numberOfPhotosLabel = UILabel()

        leftImage.contentMode = .scaleAspectFit
        mainImage.contentMode = .scaleAspectFit
        rightImage.contentMode = .scaleAspectFit

        view.addSubview(leftImage)
        view.addSubview(mainImage)
        view.addSubview(rightImage)
        view.addSubview(numberOfPhotosLabel)

        leftImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        rightImage.translatesAutoresizingMaskIntoConstraints = false
        numberOfPhotosLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            mainImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2),
            mainImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            leftImage.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            leftImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftImage.heightAnchor.constraint(equalTo: mainImage.heightAnchor),
            leftImage.widthAnchor.constraint(equalTo: mainImage.widthAnchor),

            rightImage.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            rightImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rightImage.heightAnchor.constraint(equalTo: mainImage.heightAnchor),
            rightImage.widthAnchor.constraint(equalTo: mainImage.widthAnchor),

            numberOfPhotosLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            numberOfPhotosLabel.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 40)
        ])

        leftImage.sd_setImage(with: URL(string: arrayOfPhotosFromDB[leftPhotoIndex]))
        mainImage.sd_setImage(with: URL(string: arrayOfPhotosFromDB[mainPhotoIndex]))
        rightImage.sd_setImage(with: URL(string: arrayOfPhotosFromDB[rightPhotoIndex]))
        if arrayOfPhotosFromDB.count == 1 {
            numberOfPhotosLabel.text = "1 image"
        } else {
            numberOfPhotosLabel.text = "\(indexOfSelectedPhoto + 1) of \(arrayOfPhotosFromDB.count) images"
        }

        numberOfPhotosLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

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

    func animationStarts() {
        guard mainImage != nil,
        rightImage != nil,
        leftImage != nil

        else { return }

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
        guard mainImage != nil,
        rightImage != nil,
        leftImage != nil

        else { return }

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
                                self.indexOfSelectedPhoto = (arrayOfPhotosFromDB.count) - 1
                            }
                            self.animationStarts()
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
                            if self.indexOfSelectedPhoto > arrayOfPhotosFromDB.count - 1 {
                                self.indexOfSelectedPhoto = 0
                            }
                            self.animationStarts()
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
