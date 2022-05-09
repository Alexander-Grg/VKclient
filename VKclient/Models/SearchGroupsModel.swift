//
//  SearchGroupsModel.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 13.10.2021.
//

import Foundation
//
struct SearchResponse: Codable {
    let response: SearchResponseNext
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct SearchResponseNext: Codable {
    var count: Int = 0
    let items: [SearchedObjects]
    
    enum CodingKeys: String, CodingKey {
        case count, items
    }
}

struct SearchedObjects: Codable {
     var name: String = ""
     var photo: String = ""
    
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case photo = "photo_100"
        
    }
}
