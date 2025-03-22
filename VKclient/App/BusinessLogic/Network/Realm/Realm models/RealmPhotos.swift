//
//  RealmPhotos.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 17.10.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//
//
import RealmSwift

class RealmPhotos: Object {

    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var ownerID: Int = 0
    @Persisted var sizes = Map<String, String>()

    convenience init(photos: PhotosObject) {
        self.init()
        self.id = photos.id
        self.ownerID = photos.ownerID
        self.sizes = photos.sizes    }
}
