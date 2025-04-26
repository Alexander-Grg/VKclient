//
//  FriendModel.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 05.10.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation
 struct FriendResponse: Decodable {
    var response: NextResponse
}

struct NextResponse: Decodable {
    var count: Int
    var items: [FriendObject]
    }


struct FriendObject: Decodable {
    var firstName: String
    var lastName: String
    var id: Int
    var avatar: String
    var domain: String?
    var sex: Int?
    var birthday: String?
    var city: City?
    var sexMapped: String {
        return sex == 1 ? "Female" : "Male"
    }
    var birthdayMapped: String? {
        return birthday.flatMap { DateFormatter().date(from: $0) }
            .flatMap { DateFormatter().string(from: $0) }
    }

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id = "id"
        case lastName = "last_name"
        case avatar = "photo_100"
        case domain
        case sex
        case birthday = "bdate"

    }
}

struct City: Decodable {
    var id: Int
    var title: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
}
