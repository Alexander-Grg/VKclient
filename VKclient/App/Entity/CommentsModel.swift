//
//
//  CommentsModel.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.03.2025.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//

import Foundation

struct CommentsResponse: Codable {
    let response: CommentList
}

struct CommentList: Codable {
    let count: Int
    let items: [Comment]
    let currentLevelCount: Int
    let canPost: Bool
    let showReplyButton: Bool

    enum CodingKeys: String, CodingKey {
        case count
        case items
        case currentLevelCount = "current_level_count"
        case canPost = "can_post"
        case showReplyButton = "show_reply_button"
    }
}

struct Comment: Codable {
    let id: Int
    let fromId: Int
    let date: Int
    let text: String
    let postId: Int
    let ownerId: Int
    let parentsStack: [Int]
    let thread: CommentThread

    enum CodingKeys: String, CodingKey {
        case id
        case fromId = "from_id"
        case date
        case text
        case postId = "post_id"
        case ownerId = "owner_id"
        case parentsStack = "parents_stack"
        case thread
    }
}

struct CommentThread: Codable {
    let count: Int
    let items: [Comment]
    let canPost: Bool
    let showReplyButton: Bool

    enum CodingKeys: String, CodingKey {
        case count
        case items
        case canPost = "can_post"
        case showReplyButton = "show_reply_button"
    }
}
