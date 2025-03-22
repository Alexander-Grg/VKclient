//
//  GroupSearchEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/17/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation

enum GroupSearchEndpoint: EndpointProtocol {
    case groupSearch(search: String)
    var absoluteURL: String {
        return baseURL + "/method/groups.search"
    }
    
    var parameters: [String : String] {
        switch self {
        case let .groupSearch(search):
            return [
                "sort" : "6",
                "type" : "group",
                "q": search,
                "count" : "20"
            ]
        }
    }
}
