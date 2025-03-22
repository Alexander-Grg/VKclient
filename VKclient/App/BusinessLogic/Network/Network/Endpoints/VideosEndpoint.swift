//
//  VideosEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 22/3/25.
//

import Foundation
enum VideosEndpoint: EndpointProtocol {
    case getVideo(ownIDvidIDKey: String )

    var absoluteURL: String {
        return baseURL + "/method/video.get"
    }

    var parameters: [String : String] {
        switch self {
        case let .getVideo(ownIDvidIDKey):
            return ["videos" : ownIDvidIDKey]
        }
    }
}
