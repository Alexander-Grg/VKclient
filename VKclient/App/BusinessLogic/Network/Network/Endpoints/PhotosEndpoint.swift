//
//  PhotosEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/16/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation

enum PhotosEndpoint: EndpointProtocol {
    case getPhotos(id: String)
    var parameters: [String : String] {
        switch self {
        case let .getPhotos(id):
            return [
                "rev" : "1",
                "owner_id" : id,
                "album_id" : "profile",
                "offset" : "0",
                "photo_sizes" : "0"
            ]
        }
    }
    
    var absoluteURL: String {
        return baseURL + "/method/photos.get"
    }

}

