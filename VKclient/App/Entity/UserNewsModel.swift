//
//  UserNews.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 27.11.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation

struct Users: Codable {
    var items: [User]
}

struct User: Codable, NewsSource {
    var name: String { "\(firstName) \(lastName)" }
    var urlString: String { avatar }

    var id: Int = 0
    var firstName: String
    var lastName: String
    var avatar: String

    var avatarURL: URL? {
        URL(string: avatar)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "photo_100"
    }
}
