//
//  ClassesForParsing.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 05.10.2021.
//

import Foundation
 UserResponse: Decodable {
    var response: NextResponse
}

struct NextResponse: Decodable {
    var count: Int
    var items: [UserObject]
    }


struct UserObject: Decodable {
    var firstName: String
    var lastName: String
    var id: Int
    var avatar: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id = "id"
        case lastName = "last_name"
        case avatar = "photo_100"
    }
}
