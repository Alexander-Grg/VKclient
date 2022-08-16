//
//  FriendsEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/15/22.
//

import Foundation

enum FriendsEndpoint: EndpointProtocol {
    case getFriends
    
    var baseURL: String {
        return "https://api.vk.com"
    }
    var absoluteURL: String {
        return baseURL + "/method/friends.get"
    }
    var parameters: [String : String] {
        return ["order" : "random",
                "fields" : "nickname,photo_100"
        ]
    }
}
