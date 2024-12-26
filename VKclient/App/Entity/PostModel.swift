//
//  Post.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 24.11.2021.
//

import Foundation

protocol NewsSource {
    var name: String { get }
    var urlString: String { get }
}

extension NewsSource {
    var urlImage: URL? { URL(string: urlString) }
}

struct NewsResponse: Codable {
    var response: Newsfeed
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
    var text: String?
    var attachments: [Attachment]?
    var comments: Comments?
    var likes: Likes?
    var views: Views?
    var reposts: Reposts?
    var postID: Int

    var urlProtocol: NewsSource?

    var attachmentPhotoUrl: URL? {
        guard let image = attachments?.first(where: { $0.type == "photo" }),
              let photo = image.photo?.sizes["x"] else {
            return nil
        }
        return URL(string: photo)
    }

    var attachmentPhotos: [String] {
        guard let images = attachments?.filter({ $0.type == "photo" }) else {
            return []
        }
        return images.compactMap { $0.photo?.sizes["x"] }
    }

    var attachmentVideoUrl: URL? {
        guard let videoAttachment = attachments?.first(where: { $0.type == "video" }),
              let url =  videoAttachment.video?.trackCode
        else {
            print("No video attachment found for sourceId: \(sourceId)")
            return nil
        }

        return URL(string: url)
    }

    var aspectRatio: Float {
        guard let image = attachments?.first(where: { $0.type == "photo" }),
              let aspect = image.photo?.aspectRatio else {
            return 0.0
        }
        return aspect
    }

    var videoAspectRatio: CGFloat {
        guard let videoAttachment = attachments?.first(where: { $0.type == "video" }),
              let video = videoAttachment.video,
              let width = video.width,
              let height = video.height,
              height != 0 else {
            return 0.0
        }
        return CGFloat(Float(width) / Float(height))
    }

    var isPressed: Bool = false

    var rowsCounter: [NewsTypes] {
        var rowsCounter = [NewsTypes]()
        let hasText = !(text?.isEmpty ?? true)
        let hasPhoto = attachmentPhotoUrl != nil
        let hasVideo = attachments?.contains(where: { $0.type == "video" }) ?? false

        if hasText || hasPhoto || hasVideo {
            rowsCounter.append(.header)
        }
        if hasText {
            rowsCounter.append(.text)
        }
        if hasPhoto {
            rowsCounter.append(.photo)
        } else if hasVideo {
            rowsCounter.append(.video)
        }
        if hasText || hasPhoto || hasVideo {
            rowsCounter.append(.footer)
        }

        return rowsCounter
    }

    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case date
        case text
        case attachments
        case comments
        case likes
        case views
        case reposts
        case postID = "post_id"
    }
}

// MARK: Attachments
struct Attachment: Codable {
    var type: String
    var photo: PhotosObject?
    var video: VideoObject?

    enum CodingKeys: String, CodingKey {
        case type
        case photo
        case video
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

// MARK: - Likes
struct Likes: Codable {
    let canLike: Int
    let count: Int
    let userLikes: Int
    let canPublish: Int
    let repostDisabled: Bool

    enum CodingKeys: String, CodingKey {
        case canLike = "can_like"
        case count
        case userLikes = "user_likes"
        case canPublish = "can_publish"
        case repostDisabled = "repost_disabled"
    }
}

// MARK: Reposts
struct Reposts: Codable {
    var count: Int

    enum CodingKeys: String, CodingKey {
        case count
    }
}

// MARK: Video Object
struct VideoObject: Codable {
    let canComment, canLike, canRepost, canSubscribe: Int?
    let canAddToFaves, canAdd, comments, date: Int?
    let description: String?
    let duration: Int?
    let width, height, id, ownerID: Int?
    let isFavorite: Bool?
    let trackCode: String?
    let videoRepeat: Int?
    let views, localViews, canDislike: Int?
    let wallPostID: Int?
    let shouldStretch: Bool?
    let accessKey: String?
    let added: Int?
    let reposts: Reposts?

    enum CodingKeys: String, CodingKey {
        case canComment = "can_comment"
        case canLike = "can_like"
        case canRepost = "can_repost"
        case canSubscribe = "can_subscribe"
        case canAddToFaves = "can_add_to_faves"
        case canAdd = "can_add"
        case comments, date, description, duration
        case width, height, id
        case ownerID = "owner_id"
        case isFavorite = "is_favorite"
        case trackCode = "track_code"
        case videoRepeat = "repeat"
        case views
        case localViews = "local_views"
        case canDislike = "can_dislike"
        case wallPostID = "wall_post_id"
        case shouldStretch = "should_stretch"
        case accessKey = "access_key"
        case added, reposts
    }
}

// MARK: - Video Image
struct VideoImage: Codable {
    var url: String
    var width: Int
    var height: Int
    var withPadding: Int?

    enum CodingKeys: String, CodingKey {
        case url
        case width
        case height
        case withPadding = "with_padding"
    }
}

