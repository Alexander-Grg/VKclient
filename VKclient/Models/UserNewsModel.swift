//
//  UserNews.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 27.11.2021.
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

//class UserNews: NewsSource {
//
//    var name: String { "\(firstName) \(lastName)" }
//
//    var urlString: String { photo100 }
//
//    var id: Int = 0
//    var firstName: String = ""
//    var lastName: String = ""
//    var photo100: String = ""
//
//    required convenience init(_ json: JSON) {
//        self.init()
//        self.id = json["id"].intValue
//        self.firstName = json["first_name"].stringValue
//        self.lastName = json["last_name"].stringValue
//        self.photo100 = json["photo_100"].stringValue
//    }
//
//    convenience init(id: Int, firstName: String, lastName: String, photo100: String) {
//        self.init()
//        self.id = id
//        self.firstName = firstName
//        self.lastName = lastName
//        self.photo100 = photo100
//    }
//}
