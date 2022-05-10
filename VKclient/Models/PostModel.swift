//
//  Post.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 24.11.2021.
//

import Foundation
import SwiftyJSON

protocol NewsSource {

    var name: String { get }
    var urlString : String { get }
}

extension NewsSource {
    var urlImage: URL? { URL(string: urlString)}
}

struct Newsfeed: Codable {
    var items: [News]
    var profiles: [User]
    var groups: [Community]
    var nextFrom: String
    
    enum CodingKeys: String, CodingKey {
        case items
        case profiles
        case groups
        case nextFrom = "next_from"
    }
}

// MARK: News
struct News: Codable {
    
    var sourceId: Int
    var date: Double
    var text: String
    var attachments: [Attachments]?
    var comments: Comments?
//    var likes: Likes?
    var views: Views?
    var reposts: Reposts?
    
    var urlProtocol: NewsSource?
    var url: URL? { urlString.flatMap { URL(string: $0) }}
    var urlString: String?
    var rowsCounter: [NewsTypes] {
        var rowsCounter = [NewsTypes]()
        
        rowsCounter.append(.header)
        
        
        if !text.isEmpty {
            rowsCounter.append(.text)
        }
        
        
        if urlString != nil {
            rowsCounter.append(.photo)
        }
        
        rowsCounter.append(.footer)
        
        return rowsCounter
    }
    
    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case date
        case text
        case attachments
        case comments
//        case likes
        case views
        case reposts
   
    }

}

// MARK: Attachments
struct Attachments: Codable {
    var type: String
    var photo: PhotosObject?
    
    enum CodingKeys: String, CodingKey {
        case type
        case photo
    }
}


// MARK: Comments
struct Comments: Codable {
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case count
    }
}


// MARK: Views
struct Views: Codable {
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case count
    }
}


//MARK: Likes
//struct Likes {
//    var count: Int
//}
//
//extension Likes: Codable {
//    enum CodingKeys: String, CodingKey {
//        case count
//    }
//}

// MARK: Reposts
struct Reposts: Codable {
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case count
    }
}

//
//class PostNews {
//    var sourceID: Int
//    var date: Date
//    var text: String
//    var postID: Double
//    var likes: Int
//    var comments: Int
//    var reposts: Int
//    var type: String
//    var views: Int
//    var url: URL? { urlString.flatMap { URL(string: $0) }}
//    var urlString: String?
//    var nextFrom: String
//    var width: Float
//    var height: Float
//    var aspectRatio: Float { width/height }
//
//    var urlProtocol: NewsSource?
//
//    var rowsCounter: [NewsTypes] {
//        var rowsCounter = [NewsTypes]()
//
//        rowsCounter.append(.header)
//
//
//        if !text.isEmpty {
//            rowsCounter.append(.text)
//        }
//
//
//        if urlString != nil {
//            rowsCounter.append(.photo)
//        }
//
//        rowsCounter.append(.footer)
//
//        return rowsCounter
//    }
//
//    init(_ json: JSON) {
//        self.sourceID = json["source_id"].intValue
//        self.date = Date(timeIntervalSince1970: (json["date"].doubleValue))
//        self.text = json["text"].stringValue
//        self.postID = json["post_id"].doubleValue
//        self.likes = json["likes"]["count"].intValue
//        self.comments = json["comments"]["count"].intValue
//        self.reposts = json["reposts"]["count"].intValue
//        self.views = json["views"]["count"].intValue
//        self.type = json["type"].stringValue
//        self.nextFrom = json["next_from"].stringValue
//
//
//        self.urlString = json["attachments"].arrayValue.first(where: { $0["type"] == "photo" })?["photo"]["sizes"].arrayValue.last?["url"].stringValue
//        self.height = json["attachments"].arrayValue.first(where: { $0["type"] == "photo" })?["photo"]["sizes"].arrayValue.last?["height"].floatValue ?? 0
//        self.width = json["attachments"].arrayValue.first(where: { $0["type"] == "photo" })?["photo"]["sizes"].arrayValue.last?["width"].floatValue ?? 0
//    }
//}
