//
//  ClassesForParsing.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 05.10.2021.
//

import Foundation

struct UserResponse: Decodable {
    let response: NextResponse
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct NextResponse: Decodable {
    var count: Int = 0
    let items: [UserObject]
    
    
    enum CodingKeys: String, CodingKey {
        case count, items
    }
}

struct UserObject: Decodable {
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var id: Int = 0
    dynamic var avatar: String = ""
    
    enum CodingKeys: String, CodingKey {
        
        case firstName = "first_name"
        case id = "id"
        case lastName = "last_name"
        case avatar = "photo_100"
        
    }
}


//MARK: JSON response
//{
//    "response": {
//        "count": 3,
//        "items": [
//            {
//                "first_name": "Александр",
//                "id": 20674388,
//                "last_name": "Григорьев",
//                "can_access_closed": true,
//                "is_closed": false,
//                "sex": 2,
//                "nickname": "",
//                "domain": "alexgrg",
//                "city": {
//                    "id": 1,
//                    "title": "Москва"
//                },
//                "country": {
//                    "id": 1,
//                    "title": "Россия"
//                },
//                "track_code": "c58701e4MtOw_dRz40Kqa0N7X2KmKuIBx5mFblI0naRCGwlG6aFfuL_OuSLlQK85cP3rvytJggzQguAA"
//            },
//            {
//                "first_name": "Ксения",
//                "id": 151654978,
//                "last_name": "Касаткина",
//                "can_access_closed": true,
//                "is_closed": true,
//                "sex": 1,
//                "nickname": "",
//                "domain": "ksyshenkakas",
//                "city": {
//                    "id": 74,
//                    "title": "Курган"
//                },
//                "country": {
//                    "id": 1,
//                    "title": "Россия"
//                },
//                "track_code": "d155c2814qK_1VeayVU9beRxhMkOCZJM9ynCnrEHRLjSMg32iQOPybDjZs3MUG870fY_Kuhm4VjuJdXw1Q"
//            },
//            {
//                "first_name": "Михаил",
//                "id": 175050127,
//                "last_name": "Григорьев",
//                "can_access_closed": true,
//                "is_closed": true,
//                "sex": 2,
//                "nickname": "",
//                "domain": "nerxuz",
//                "track_code": "cedcc385-4gL0zqG7sfKca8R_gPecZ5Lrx50BODPpHzX_Xehn6OW4wXnCoTrx891nZ5A7zge7V-2EmNqhA"
//            }
//        ]
//    }
//}
