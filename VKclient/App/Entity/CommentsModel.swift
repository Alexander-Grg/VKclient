//
//
//  CommentsModel.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.03.2025.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//

import Foundation

import Foundation

struct CommentApiResponse: Decodable {
    let response: CommentFirstLayer
}

struct CommentFirstLayer: Decodable {
    let count: Int
    let items: [CommentModel]
    let currentLevelCount: Int
    let canPost: Bool
    let showReplyButton: Bool

    enum CodingKeys: String, CodingKey {
        case count, items
        case currentLevelCount = "current_level_count"
        case canPost = "can_post"
        case showReplyButton = "show_reply_button"
    }
}

struct CommentModel: Decodable {
    let id: Int
    let fromID: Int
    let date: Int
    let text: String
    let postID: Int
    let ownerID: Int
    let parentsStack: [Int]
    let thread: Thread

    enum CodingKeys: String, CodingKey {
        case id
        case fromID = "from_id"
        case date
        case text
        case postID = "post_id"
        case ownerID = "owner_id"
        case parentsStack = "parents_stack"
        case thread
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
