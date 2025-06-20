//
//
//  UserEndpoint.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 31.03.2025.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//
    
enum UserEndpoint: EndpointProtocol {
    case getUsers(Ids: [Int])
    case getWall(userId: String, offset: Int?)

    var absoluteURL: String {
        switch self {
        case .getUsers:
            return baseURL + "/method/users.get"
        case .getWall:
            return baseURL + "/method/wall.get"
        }
    }

    var parameters: [String : String] {
        switch self {
        case let .getUsers(Ids):
            return ["user_ids" : Ids.count == 1 ? String(Ids[0]) : Ids.map { String($0) }.joined(separator: ","),
                    "fields" : "education, has_photo, sex, city, education, country, occupation, relatives, connections, site, friends_count, followers_count, mutual_friends_count, about, photo_50, photo_100, photo_200, photo_400, photo_max, online, lists, activities, music, books, games, about, can_post, can_see_all_posts, is_closed, has_wall, contacts, education, verified, connections, relatives, site, status,"]
        case let .getWall(Id, offset):
            return [
                "domain" : Id,
                "extended" : "1",
                "offset" : String(offset ?? 0),
                "count" : "100"
            ]
        }
    }
}

