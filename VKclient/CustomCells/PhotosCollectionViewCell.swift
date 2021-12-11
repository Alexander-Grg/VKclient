//
//  PhotosCollectionViewCell.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 07.09.2021.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var likeControl: LikeControl!
    static private let reusedIdentifier = "PhotosCell"
    @IBOutlet var collectionViewCell: UIView!
    @IBOutlet var photoCollectionCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeControl.backgroundColor = nil

    }
    
    
    func configure(image: UIImage?) {
    }
    
}
