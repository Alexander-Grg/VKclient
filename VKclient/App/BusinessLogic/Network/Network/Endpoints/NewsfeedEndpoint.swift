//
//  NewsfeedEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/17/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
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
                "filters" : "post, photo, photo_tag, wall_photo, friend",
                "count" : "20",
                "start_from" : startFrom
            ]
        }
    }
}
