//
//  GroupsModel.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 07.10.2021.
//

import Foundation

struct GroupsResponse: Codable {
    var response: GroupsNextResponse
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct GroupsNextResponse: Codable {
    var count: Int = 0
    var items: [GroupsObjects]
    
    enum CodingKeys: String, CodingKey {
        case count, items
    }
}

struct GroupsObjects: Codable {
    var name: String = ""
    var id: Int = 0
    var photo: String = ""
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case id = "id"
        case photo = "photo_100"
        
    }
}

//MARK: JSON response
//"response": {
//       "count": 7,
//       "items": [
//           {
//               "id": 25679656,
//               "name": "Тонкий юмор",
//               "screen_name": "sarsar",
//               "is_closed": 0,
//               "type": "page",
//               "photo_50": "https://sun6-22.userapi.com/s/v1/if1/vICiSBJCnzMVbo4bhALZ3MIpTAzXPzPE_VC_KMmQW3EIEfBztgjxZZ7prOMF1M43VJp5Kzdq.jpg?size=50x50&quality=96&crop=0,2,398,398&ava=1",
//               "photo_100": "https://sun6-22.userapi.com/s/v1/if1/ucMCW8CBwYhG4OIORIHJM4kK5p5Lxok73yQPXXEmqSo3pRK7In1URbSd_BYU89lOT_gncsE-.jpg?size=100x100&quality=96&crop=0,2,398,398&ava=1",
//               "photo_200": "https://sun6-22.userapi.com/s/v1/if1/EZz34_hxVHfJfsIapPFbHBCVeuOdnoF3VvhH_Uwf4tjTlam5ylvIxB83ymurd8hvFxZSfBkx.jpg?size=200x200&quality=96&crop=0,2,398,398&ava=1"
//           },
//           {
//               "id": 82545064,
//               "name": "Интересные факты",
//               "screen_name": "interst_facts",
//               "is_closed": 0,
//               "type": "page",
//               "photo_50": "https://sun6-23.userapi.com/s/v1/if1/-17xAmbrV5JgzX0EpnLjjRWUmkVuW-mRyq0u4NSdmmjGOtXlE5zXTX6hnIzSb8fcM8WwLyNN.jpg?size=50x50&quality=96&crop=0,0,200,200&ava=1",
//               "photo_100": "https://sun6-23.userapi.com/s/v1/if1/1ENhO7mDenx1h-PLBIQoBLyfZr5wQy7M2oUCiLfMcu5znLMi0lCD06I_LU4GbYt41tNc_ebB.jpg?size=100x100&quality=96&crop=0,0,200,200&ava=1",
//               "photo_200": "https://sun6-23.userapi.com/s/v1/if1/D47s2kKLQqHgGzm56tgVECxcsqGWzkz40lhVexnBicLeYMINe1o9RQERrEvZBIbhBG-kDimd.jpg?size=200x200&quality=96&crop=0,0,200,200&ava=1"
//           },
//           {
//               "id": 95385562,
//               "name": "Факты из Истории",
//               "screen_name": "historycal_facts",
//               "is_closed": 0,
//               "type": "page",
//               "photo_50": "https://sun6-21.userapi.com/s/v1/if1/87h4-BXgYKAZUlcccEmlqIXviyWTPvQwj2X8gXMQ3Rq0i7_ya9MIjj1tzqEMM-yTlY44C7xl.jpg?size=50x50&quality=96&crop=16,36,272,272&ava=1",
//               "photo_100": "https://sun6-21.userapi.com/s/v1/if1/b8OTpaSPkfjgxgECRBRFEVCx6wKsXXRau083aoor2eWyXok0oHCRssIdDzAYG9E7XtwTKnxE.jpg?size=100x100&quality=96&crop=16,36,272,272&ava=1",
//               "photo_200": "https://sun6-21.userapi.com/s/v1/if1/zFrHJcvMLFKweSoTAEb8ct30mDGfL9xuIXo3ImmPXAkgrsxPtqACHh86dSVT5rWxiuRBIayz.jpg?size=200x200&quality=96&crop=16,36,272,272&ava=1"
//           },
//           {
//               "id": 32194500,
//               "name": "21 ВЕК ♔",
//               "screen_name": "mens_gq",
//               "is_closed": 0,
//               "type": "page",
//               "photo_50": "https://sun6-23.userapi.com/s/v1/ig2/-oklMilS_XXCnsH8d7wBxDERijUbvJp0Vr_QcTMSxNM0wkcMN3GOB5ZNK8JlA1hdQl6U8R6V_EiM7siQWPDZHZ9a.jpg?size=50x50&quality=96&crop=66,66,368,368&ava=1",
//               "photo_100": "https://sun6-23.userapi.com/s/v1/ig2/3SblRQj5-to6KtLvzXhOEKDEfgPCtYk7e7f80GE7_KkA-85dNKDpb_3kE6VKnxmr1e6IujhZaq4Ou_ZifK4rDnBQ.jpg?size=100x100&quality=96&crop=66,66,368,368&ava=1",
//               "photo_200": "https://sun6-23.userapi.com/s/v1/ig2/C5459k1Ar5I_0ScYC2eCH1YBKNZb9DZfymgSinDqWiJX820GhCQxwWQHSNXfrsK9rOge8vna3ay35onbI1u82g6e.jpg?size=200x200&quality=96&crop=66,66,368,368&ava=1"
//           },
//           {
//               "id": 76829316,
//               "name": "Анекдоты",
//               "screen_name": "hurma_app",
//               "is_closed": 0,
//               "type": "page",
//               "photo_50": "https://sun6-20.userapi.com/s/v1/ig2/J1lHP8-dhiobB0Dz6czMwkxhQse-DZVm5iD6VbYYKgsalvHIJNyrK1vaqhh16F2ayZu-UaU3V_XaT5sQFEopyieM.jpg?size=50x50&quality=96&crop=0,0,512,512&ava=1",
//               "photo_100": "https://sun6-20.userapi.com/s/v1/ig2/zK_hZ5a0YI598BDiCzEY1fgwBP_X7iNBo2imlb6Q-pDa2ClG5woLaCyNdojly4s0E-vDOY5X-uCzy-PmcKRHBiHS.jpg?size=100x100&quality=96&crop=0,0,512,512&ava=1",
//               "photo_200": "https://sun6-20.userapi.com/s/v1/ig2/bzLHDw4_93UB0-AKN9QVsuzePVohRKHWPADoITwFqSJNseAUrMJVARt-GNaviFkzpSmwadLU3mDwLbZ3OSxFSAin.jpg?size=200x200&quality=96&crop=0,0,512,512&ava=1"
//           },
//           {
//               "id": 15414754,
//               "name": "Знаете ли Вы?",
//               "screen_name": "vk.facti",
//               "is_closed": 0,
//               "type": "page",
//               "photo_50": "https://sun6-22.userapi.com/s/v1/if2/GycuC3bLlw9o9Hf96Ht0lX_tQmiHqpC9SgV2OtrfS57rsKVsZ9ZrrReOpV8ISDuvPQFlVK9tSqT7k1SJCDxZFH3Z.jpg?size=50x50&quality=96&crop=0,0,200,200&ava=1",
//               "photo_100": "https://sun6-22.userapi.com/s/v1/if2/Mc5jK2NWPilebSGGo3Aasz_VLoyVcg-pcuc-akU8mmrzi7zSx3txBMzF1gwn4maklhlDVIcRPkjemJGBnEeF9SBz.jpg?size=100x100&quality=96&crop=0,0,200,200&ava=1",
//               "photo_200": "https://sun6-22.userapi.com/s/v1/if2/CxPh-sVBGHu5x0QoKo5jyo8DFBc8yNvrui9L_3wV7_4kmJThvtDuwyhYU7MrYb5YYLxroadsjjvK06NXJgJUsnDz.jpg?size=200x200&quality=96&crop=0,0,200,200&ava=1"
//           },
//           {
//               "id": 10045027,
//               "name": "Лепрозорий",
//               "screen_name": "aloloya",
//               "is_closed": 0,
//               "type": "page",
//               "photo_50": "https://sun6-21.userapi.com/s/v1/ig2/Nb4J2w-MHcRVs8tXZiKZfiPpQ5qcY2cKlIyS8_EfnwotKYYQ5zyFv4DmqRaqZAHKGXrlATvFdxMr_z1AktcZjTvU.jpg?size=50x50&quality=96&crop=9,12,340,340&ava=1",
//               "photo_100": "https://sun6-21.userapi.com/s/v1/ig2/thlxiTqZlSw6QhDfaltH2r4JnZ2rGVtqUBZu-5C3tInjP_KssLad5jKmPA8PF76doGD6UtMXelkM9iF81V8YCw5u.jpg?size=100x100&quality=96&crop=9,12,340,340&ava=1",
//               "photo_200": "https://sun6-21.userapi.com/s/v1/ig2/ALfsovy2SooHWQQAvM-DWqtMOZT7owY78xFg5qPmRGnQE0pqBjb9b5uXvHoQW8ETTUCGl9VoZPGlT0DdLVLgAHlh.jpg?size=200x200&quality=96&crop=9,12,340,340&ava=1"
//           }
//       ]
//   }
//}
