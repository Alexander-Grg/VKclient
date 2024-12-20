//
//  LikesEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 13/12/24.
//
import Foundation
enum LikesEndpoint: EndpointProtocol {
    case setLike(type: String, itemID: String)
    case removeLike(type: String, itemID: String)
    case isLiked(type: String, itemID: String)

    var absoluteURL: String {
        switch self {
        case let .setLike(type, itemID):
            return baseURL + "method/likes.add"
        case let .isLiked(type, itemID):
            return baseURL + "method/likes.isLiked"
        case let .removeLike(type, itemID):
            return baseURL + "method/likes.delete"
        }
    }

    var parameters: [String : String] {
        switch self {
        case let .setLike(type, itemID):
            return [
                "type" : type,
                "item_id" : itemID
            ]
        case let .isLiked(type, itemID):
            return [
                "type" : type,
                "item_id" : itemID
            ]
        case let .removeLike(type, itemID):
            return [
                "type" : type,
                "item_id" : itemID
            ]
        }
    }
}
