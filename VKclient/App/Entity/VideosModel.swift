//
//  VideosModel.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 22/3/25.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//

import Foundation

struct VideoApiResponse: Codable {
    let response: VideoResponse
}

struct VideoResponse: Codable {
    let count: Int
    let items: [VideoItem]
    let maxAttachedShortVideos: Int?

    enum CodingKeys: String, CodingKey {
        case count, items
        case maxAttachedShortVideos = "max_attached_short_videos"
    }
}

struct VideoItem: Codable {
//    let canBePinned: Bool
//    let isPinned: Bool
//    let responseType: String
//    let accessKey: String?
//    let canComment, canLike, canRepost, canSubscribe: Int
//    let canAddToFaves, canAdd, comments: Int
//    let date: Int
//    let description: String
//    let duration: Int
//    let image, firstFrame: [Image]
//    let width, height, id, ownerId: Int
//    let ovId, title: String
//    let isFavorite: Bool?
    let image: [VideoResponseImage]
    let player: String
//    let added: Int
//    let trackCode, type: String
//    let views, localViews: Int
//    let likes: Likes
//    let reposts: Reposts
//    let canDislike: Int

    enum CodingKeys: String, CodingKey {
//        case canBePinned = "can_be_pinned"
//        case isPinned = "is_pinned"
//        case responseType = "response_type"
//        case accessKey = "access_key"
//        case canComment = "can_comment"
//        case canLike = "can_like"
//        case canRepost = "can_repost"
//        case canSubscribe = "can_subscribe"
//        case canAddToFaves = "can_add_to_faves"
//        case canAdd = "can_add"
//        case comments, date, description, duration, image
//        case firstFrame = "first_frame"
//        case width, height, id
//        case ownerId = "owner_id"
//        case ovId = "ov_id"
//        case title, isFavorite, player, added
//        case trackCode = "track_code"
//        case type, views
//        case localViews = "local_views"
//        case likes, reposts
//        case canDislike = "can_dislike"
        case player
        case image
    }
}

struct VideoResponseImage: Codable {
    let url: String
    let width, height: Int
    let withPadding: Int?

    enum CodingKeys: String, CodingKey {
        case url, width, height
        case withPadding = "with_padding"
    }
}
