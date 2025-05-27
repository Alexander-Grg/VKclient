//
//  PhotosModel.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 07.10.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation
import RealmSwift

struct PhotosResponse: Codable {
    var response: Response
}

struct Response: Codable {
    var count: Int = 0
    var items: [PhotosObject]
}

struct PhotosObject: Codable, PostSource {
    var name: String = ""
    var urlString: String { sizes["x"]! }

    var id: Int = 0
    var ownerID: Int = 0
    var sizes = Map<String, String>()
    var aspectRatio: Float { width/height }
    var height: Float = 0
    var width: Float = 0
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes
    }
    enum PhotoKeys: String, CodingKey {
        case height, url, type, width
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.ownerID = try values.decode(Int.self, forKey: .ownerID)
        var photosValue = try values.nestedUnkeyedContainer(forKey: .sizes)
        while !photosValue.isAtEnd {
            let photo = try photosValue.nestedContainer(keyedBy: PhotoKeys.self)
            let photoType = try photo.decode(String.self, forKey: .type)
            let photoURL = try photo.decode(String.self, forKey: .url)
            let photoHeight = try photo.decode(Float.self, forKey: .height)
            let photoWidth = try photo.decode(Float.self, forKey: .width)
            sizes[photoType] = photoURL
            height = photoHeight
            width = photoWidth
        }
    }
}
