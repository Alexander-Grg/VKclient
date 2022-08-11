//
//  ClassesForParsing.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 05.10.2021.
//

import Foundation

struct UserResponse: Codable {
    let response: NextResponse
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct NextResponse: Codable {
    var count: Int = 0
    let items: [UserObject]
    enum CodingKeys: String, CodingKey {
        case count, items
    }
}

struct UserObject: Codable {
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var id: Int = 0
    dynamic var avatar: String = ""
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id = "id"
        case lastName = "last_name"
        case avatar = "photo_100"
    }
}
