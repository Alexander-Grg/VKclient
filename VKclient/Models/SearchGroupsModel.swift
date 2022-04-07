//
//  SearchGroupsModel.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 13.10.2021.
//

import Foundation
//
final class SearchResponse: Codable {
    let response: SearchResponseNext
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

final class SearchResponseNext: Codable {
    var count: Int = 0
    let items: [SearchedObjects]
    
    enum CodingKeys: String, CodingKey {
        case count, items
    }
}

final class SearchedObjects: Codable {
    dynamic var name: String = ""
    dynamic var photo: String = ""
    
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case photo = "photo_100"
        
    }
}
