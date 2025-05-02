//
//
//  LikesResponseModel.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 27. 4. 2025..
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//
    
import Foundation

struct LikesResponseAPI: Codable {
    let response: LikesResponseModel
}

struct LikesResponseModel: Codable {
    let likes: Int
}
