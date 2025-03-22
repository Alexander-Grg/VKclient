//
//  LikesEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 13/12/24.
//  Copyright © 2024–2025 Alexander Grigoryev. All rights reserved.
//
import Foundation
enum LikesEndpoint: EndpointProtocol {
    case setLike(type: String, itemID: String, ownerID: String)
    case removeLike(type: String, itemID: String, ownerID: String)
    case isLiked(type: String, itemID: String, ownerID: String)

    var absoluteURL: String {
        switch self {
        case .setLike(_, _,_):
            return baseURL + "/method/likes.add"
        case .isLiked(_, _, _):
            return baseURL + "/method/likes.isLiked"
        case .removeLike(_, _, _):
            return baseURL + "/method/likes.delete"
        }
    }

    var parameters: [String : String] {
        switch self {
        case let .setLike(type, itemID, ownerID):
            return [
                "type" : type,
                "item_id" : itemID,
                "owner_id" : ownerID
            ]
        case let .isLiked(type, itemID, ownerID):
            return [
                "type" : type,
                "item_id" : itemID,
                "owner_id" : ownerID
            ]
        case let .removeLike(type, itemID, ownerID):
            return [
                "type" : type,
                "item_id" : itemID,
                "owner_id" : ownerID
            ]
        }
    }
}
