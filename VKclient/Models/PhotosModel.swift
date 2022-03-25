//
//  PhotosModel.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 07.10.2021.
//

import Foundation
import RealmSwift

struct PhotosResponse: Codable {
    let response: Response
}

struct Response: Codable {
    var count: Int = 0
    let items: [PhotosObject]
}

struct PhotosObject: Codable {
    var id: Int = 0
    var ownerID: Int = 0
    var sizes = Map<String, String>()
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes
    }
    
    enum PhotoKeys: String, CodingKey {
        case height, url, type, width
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.ownerID = try values.decode(Int.self, forKey: .ownerID)
        
        var photosValue = try values.nestedUnkeyedContainer(forKey: .sizes)
        
        while !photosValue.isAtEnd {
            let photo = try photosValue.nestedContainer(keyedBy: PhotoKeys.self)
            let photoType = try photo.decode(String.self, forKey: .type)
            let photoURL = try photo.decode(String.self, forKey: .url)
            sizes[photoType] = photoURL
        }
    }
}


//MARK: JSON response
//{
//    "response": {
//        "count": 1,
//        "items": [
//            {
//                "album_id": -6,
//                "date": 1633272583,
//                "id": 457239021,
//                "owner_id": 678346847,
//                "has_tags": false,
//                "post_id": 2,
//                "sizes": [
//                    {
//                        "height": 54,
//                        "url": "https://sun9-12.userapi.com/impg/BCoKBgtmMyHCFZNGO02LkyK5Soe693RvtmH6bw/wA6PocXv75E.jpg?size=75x54&quality=95&sign=f5217813d52bff3ce8067c5fd7671130&c_uniq_tag=DYrvPPrg1y_YtXu4MLpgPp561xFavOJdv3cWqsUNTu4&type=album",
//                        "type": "s",
//                        "width": 75
//                    },
//                    {
//                        "height": 93,
//                        "url": "https://sun9-12.userapi.com/impg/BCoKBgtmMyHCFZNGO02LkyK5Soe693RvtmH6bw/wA6PocXv75E.jpg?size=130x93&quality=95&sign=793a1dd82f923cff21e3a1f4af3e1bbf&c_uniq_tag=jALv4Ml2LO1B-kUpq0q8paRcsgO5pcKnPoV4NqKPPh8&type=album",
//                        "type": "m",
//                        "width": 130
//                    },
//                    {
//                        "height": 433,
//                        "url": "https://sun9-12.userapi.com/impg/BCoKBgtmMyHCFZNGO02LkyK5Soe693RvtmH6bw/wA6PocXv75E.jpg?size=604x433&quality=95&sign=d0ec333f6d4e041578198d8fb9374376&c_uniq_tag=-t28cwAeDbUtOT_f6BNGIqOTp2D-DTKJ1Ic5iotXoMA&type=album",
//                        "type": "x",
//                        "width": 604
//                    },
//                    {
//                        "height": 462,
//                        "url": "https://sun9-12.userapi.com/impg/BCoKBgtmMyHCFZNGO02LkyK5Soe693RvtmH6bw/wA6PocXv75E.jpg?size=644x462&quality=95&sign=7b67acef18a0dbff9c403290f5d79c44&c_uniq_tag=wVWIES9dCr66iuCTcVRHwrYWbeo49xMjIxJYvsulnIE&type=album",
//                        "type": "y",
//                        "width": 644
//                    },
//                    {
//                        "height": 462,
//                        "url": "https://sun9-12.userapi.com/impg/BCoKBgtmMyHCFZNGO02LkyK5Soe693RvtmH6bw/wA6PocXv75E.jpg?size=644x462&quality=95&sign=7b67acef18a0dbff9c403290f5d79c44&c_uniq_tag=wVWIES9dCr66iuCTcVRHwrYWbeo49xMjIxJYvsulnIE&type=album",
//                        "type": "z",
//                        "width": 644
//                    },
//                    {
//                        "height": 93,
//                        "url": "https://sun9-12.userapi.com/impg/BCoKBgtmMyHCFZNGO02LkyK5Soe693RvtmH6bw/wA6PocXv75E.jpg?size=130x93&quality=95&sign=793a1dd82f923cff21e3a1f4af3e1bbf&c_uniq_tag=jALv4Ml2LO1B-kUpq0q8paRcsgO5pcKnPoV4NqKPPh8&type=album",
//                        "type": "o",
//                        "width": 130
//                    },
//                    {
//                        "height": 143,
//                        "url": "https://sun9-12.userapi.com/impg/BCoKBgtmMyHCFZNGO02LkyK5Soe693RvtmH6bw/wA6PocXv75E.jpg?size=200x143&quality=95&sign=be131142544781bccfcb362547bb0adb&c_uniq_tag=imQx8RqaYy0pG1hOymA-VDmir2KI4R_XLgtiIyy7Iew&type=album",
//                        "type": "p",
//                        "width": 200
//                    },
//                    {
//                        "height": 230,
//                        "url": "https://sun9-12.userapi.com/impg/BCoKBgtmMyHCFZNGO02LkyK5Soe693RvtmH6bw/wA6PocXv75E.jpg?size=320x230&quality=95&sign=efa4ccf33224ac2fe8e40714de765aa4&c_uniq_tag=iEsDjnkYeEG4_3DEvrj4pO9v5UFmJPdLAwQHvMBG7Ak&type=album",
//                        "type": "q",
//                        "width": 320
//                    },
//                    {
//                        "height": 366,
//                        "url": "https://sun9-12.userapi.com/impg/BCoKBgtmMyHCFZNGO02LkyK5Soe693RvtmH6bw/wA6PocXv75E.jpg?size=510x366&quality=95&sign=59738877d8f484e51ab66b07c42bba4e&c_uniq_tag=FmfQchwCrdxkmir4urSZ8hVwmljAB7sdu1Roh5cHnsY&type=album",
//                        "type": "r",
//                        "width": 510
//                    }
//                ],
//                "text": "",
//                "likes": {
//                    "user_likes": 0,
//                    "count": 1
//                },
//                "reposts": {
//                    "count": 1
//                },
//                "comments": {
//                    "count": 0
//                },
//                "can_comment": 1,
//                "tags": {
//                    "count": 0
//                }
//            }
//        ]
//    }
//}
