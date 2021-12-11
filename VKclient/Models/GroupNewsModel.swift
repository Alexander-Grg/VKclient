//
//  GroupNewsModel.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 27.11.2021.
//

import Foundation
import SwiftyJSON


class GroupNews: NewsSource {
    var urlString: String { photo100 }
    var pictureUrl: URL? { URL(string: photo100) }
    
    
    var id: Int = 0
    var name: String = ""
    var photo100: String = ""
    
    required convenience init(_ json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photo100 = json["photo_100"].stringValue
    }
    
    convenience init(id: Int, name: String, photo100: String) {
        self.init()
        self.id = id
        self.name = name
        self.photo100 = photo100
    }
}
