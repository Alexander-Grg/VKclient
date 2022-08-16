//
//  PhotosEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/16/22.
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
//    var parameters: [String : String] {
//        return [
//            "rev" : "1",
//            "owner_id" : String(Session.instance.friendID),
//            "album_id" : "profile",
//            "offset" : "0",
//            "photo_sizes" : "0"
//        ]
//    }
}

