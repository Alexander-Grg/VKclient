//
//
//  UserModel.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 31.03.2025.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//
    
import Foundation

struct UserModelResponse: Codable {
    let response: [UserModel]
}

struct UserModel: Codable, Hashable {
    let id: Int
    let hasPhoto: Int
    let sex: Int
    let firstName: String
    let lastName: String
    let canAccessClosed: Bool
    let isClosed: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case hasPhoto = "has_photo"
        case sex
        case firstName = "first_name"
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isClosed = "is_closed"
    }
}
