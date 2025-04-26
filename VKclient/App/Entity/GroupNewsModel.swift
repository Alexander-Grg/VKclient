//
//  GroupNewsModel.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 27.11.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation

struct UserGroups: Codable {
    var items: [Community]
}

struct PopularGroups: Codable {
    var items: [Community]
}

struct Community: NewsSource {
var urlString: String { photo }
var pictureUrl: URL? { URL(string: photo) }
var id: Int
var name: String
var photo: String
    var photoURL: URL? {
        URL(string: photo)
    }
}

extension Community: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photo = "photo_100"
    }
}
