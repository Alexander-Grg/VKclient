//
//  NewsfeedEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/17/22.
//

import Foundation

enum NewsfeedEndpoint: EndpointProtocol {
case getNews(startFrom: String = "")
    
    var absoluteURL: String {
        return baseURL + "/method/newsfeed.get"
    }
    var parameters: [String : String] {
        switch self {
        case let .getNews(startFrom):
            return [
                "filters" : "post,photo,video",
                "count" : "20",
                "start_from" : startFrom
            ]
        }
    }
}
