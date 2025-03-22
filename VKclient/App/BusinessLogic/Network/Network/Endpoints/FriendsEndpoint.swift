//
//  FriendsEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/15/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation

enum FriendsEndpoint: EndpointProtocol {
    case getFriends

    var absoluteURL: String {
        return baseURL + "/method/friends.get"
    }
    var parameters: [String : String] {
        return ["order" : "random",
                "fields" : "nickname,photo_100"
        ]
    }
}
