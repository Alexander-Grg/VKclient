//
//  GroupsModel.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 07.10.2021.
//

import Foundation

struct GroupsResponse: Codable {
    var response: GroupsNextResponse
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct GroupsNextResponse: Codable {
    var count: Int = 0
    var items: [GroupsObjects]
    enum CodingKeys: String, CodingKey {
        case count, items
    }
}

struct GroupsObjects: Codable {
    var name: String = ""
    var id: Int = 0
    var photo: String = ""
    var photo200: String = ""
    var cover: Cover?
    var isClosed: Int
    var isMember: Int
    var isDeactivated: String?
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case photo = "photo_100"
        case photo200 = "photo_200"
        case isClosed = "is_closed"
        case isMember = "is_member"
        case isDeactivated = "deactivated"
        case cover
    }
}

struct Cover: Codable {
    var isEnabled: Int?
    var images: [CoverImage]?

    enum CodingKeys: String, CodingKey {
        case isEnabled
        case images
    }
}

struct CoverImage: Codable {
    var url: String
    var width: Int
    var height: Int

    enum CodingKeys: String, CodingKey {
        case url
        case width
        case height
    }
}
