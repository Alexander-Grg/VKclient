//
//
//  CommentsEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.03.2025.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//

import Foundation

enum CommentsEndpoint: EndpointProtocol {
    case getNewsComments(ownerID: Int, postID: Int)

    var absoluteURL: String {
        return baseURL + "/method/wall.getComments"
    }

    var parameters: [String : String] {
        switch self {
        case let .getNewsComments(ownerID, postID):
            return ["owner_id" : "\(ownerID)",
                    "post_id" : "\(postID)"]
        }
    }
}
