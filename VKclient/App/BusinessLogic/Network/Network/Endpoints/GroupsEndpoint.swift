//
//  GroupsEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/16/22.
//

import Foundation

enum GroupsEndpoint: EndpointProtocol {
    case getGroups
 
    var absoluteURL: String {
        return baseURL + "/method/groups.get"
    }
    
    var parameters: [String : String] {
        return ["extended" : "1",
                "fields" : "photo_100,photo_200,cover,is_closed,deactivated,is_member"]
    }
}

