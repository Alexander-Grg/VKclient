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
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case photo = "photo_100"
    }
}
