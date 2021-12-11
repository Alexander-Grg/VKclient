//
//  UserNews.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 27.11.2021.
//

import Foundation
import SwiftyJSON

class UserNews: NewsSource {
    
    var name: String { "\(firstName) \(lastName)" }
    
    var urlString: String { photo100 }
    
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var photo100: String = ""
    
    required convenience init(_ json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo100 = json["photo_100"].stringValue
    }
    
    convenience init(id: Int, firstName: String, lastName: String, photo100: String) {
        self.init()
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.photo100 = photo100
    }
}
