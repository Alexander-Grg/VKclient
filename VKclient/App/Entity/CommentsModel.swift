//
//
//  CommentsModel.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.03.2025.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//
import Foundation

struct CommentApiResponse: Decodable {
    let response: CommentFirstLayer
}

struct CommentFirstLayer: Decodable {
    let count: Int
    let items: [CommentModel]
    let profiles: [CommentUserModel]
    let groups: [CommentGroupModel]
    let currentLevelCount: Int
    let canPost: Bool
    let showReplyButton: Bool
    let postAuthorID: Int?
    let groupsCanPost: Bool?

    enum CodingKeys: String, CodingKey {
        case count, items
        case currentLevelCount = "current_level_count"
        case canPost = "can_post"
        case showReplyButton = "show_reply_button"
        case profiles
        case groups
        case postAuthorID = "post_author_id"
        case groupsCanPost = "groups_can_post"
    }
}

struct CommentModel: Decodable, Equatable, Hashable {
    let id: Int
    let fromID: Int
    let date: Int
    let text: String
    let postID: Int?
    let ownerID: Int?
    let parentsStack: [Int]
    let thread: Thread
    let likes: CommentLikes?
    let attachments: [CommentsAttachment]?
    var isLiked: Bool? {
        self.likes?.canLike == 1 ? false : true
    }
    let deleted: Bool?

    var attachmentSticker: [(url: String, width: Int, height: Int)] {
        guard let stickers = attachments?.filter({ $0.type == "sticker" }) else {
            return []
        }
        return stickers.compactMap { attachment in
            let preferredImages = attachment.sticker?.imagesWithBackground.isEmpty == false
                ? attachment.sticker?.imagesWithBackground
                : attachment.sticker?.images

            if let image = preferredImages?.max(by: { $0.width < $1.width }) {
                  return (url: image.url, width: image.width, height: image.height)
              }
              return nil
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case fromID = "from_id"
        case date
        case text
        case postID = "post_id"
        case ownerID = "owner_id"
        case parentsStack = "parents_stack"
        case thread
        case likes
        case attachments
        case deleted
    }

    static func == (lhs: CommentModel, rhs: CommentModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Thread: Decodable {
    let count: Int
    let items: [CommentModel]
    let canPost: Bool
    let showReplyButton: Bool

    enum CodingKeys: String, CodingKey {
        case count, items
        case canPost = "can_post"
        case showReplyButton = "show_reply_button"
    }
}

struct CommentsAttachment: Decodable {
    let type: String
    let sticker: Sticker?
    let video: VideoObject?

    enum CodingKeys: String, CodingKey {
        case type
        case sticker
        case video
    }
}

struct Sticker: Decodable {
    let innerType: String
    let stickerID, productID: Int
    let images: [StickerImage]
    let imagesWithBackground: [StickerImage]
    let isAllowed: Bool
    let animationUrl: String?

    enum CodingKeys: String, CodingKey {
        case innerType = "inner_type"
        case stickerID = "sticker_id"
        case productID = "product_id"
        case images
        case imagesWithBackground = "images_with_background"
        case isAllowed = "is_allowed"
        case animationUrl = "animation_url"
    }
}

struct StickerImage: Decodable {
    let url: String
    let width: Int
    let height: Int

    enum CodingKeys: String, CodingKey {
        case url
        case width
        case height
    }
}


struct CommentLikes: Decodable {
    let canLike: Int
    let count: Int
    let userLikes: Int

    enum CodingKeys: String, CodingKey {
        case canLike = "can_like"
        case count
        case userLikes = "user_likes"
    }
}

struct CommentUserModel: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let canAccessClosed: Bool
    let isClosed: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isClosed = "is_closed"
    }
}

struct CommentGroupModel: Decodable {
    let id: Int
    let name: String
    let screenName: String
    let isClosed: Int
    let type: String
    let isAdmin: Int
    let isMember: Int
    let isAdvertiser: Int
    let photo50: String
    let photo100: String
    let photo200: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}
