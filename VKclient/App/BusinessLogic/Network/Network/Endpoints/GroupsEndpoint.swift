//
//  GroupsEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-08.
//

import Foundation

enum GroupsEndpoint: EndpointProtocol {
    case getGroups
    case joinGroup(groupID: Int)
    case leaveGroup(groupID: Int)

    var absoluteURL: String {
        switch self {
        case .getGroups:
            return baseURL + "/method/groups.get"
        case .joinGroup(groupID: _):
            return baseURL + "/method/groups.join"
        case .leaveGroup(groupID: _):
            return baseURL + "/method/groups.leave"
        }
    }

    var parameters: [String : String] {
        switch self {
        case .getGroups:
            return ["extended" : "1",
                "fields" : "photo_100,photo_200,cover,is_closed,deactivated,is_member"]
        case .joinGroup(let groupID):
            return ["group_id" : "\(groupID)",
                "not_sure" : "1"]
        case .leaveGroup(let groupID):
            return ["group_id" : "\(groupID)",]
        }
    }
}

