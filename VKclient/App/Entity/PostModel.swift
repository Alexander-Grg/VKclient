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
    var urlImage: URL? { URL(string: urlString)}
}

struct NewsResponse: Codable {
    let response: Newsfeed
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
    var text: String
    var attachments: [Attachments]?
    var comments: Comments?
    var likes: Likes?
    var views: Views?
    var reposts: Reposts?

    var urlProtocol: NewsSource?

    var attachmentPhotoUrl: URL? {
        guard
            let image = attachments?.first(where: { $0.type == "photo"}),
            let photo = image.photo?.sizes["x"]
        else { return nil }
        return URL(string: photo)
    }

    var aspectRatio: Float {
       guard  let image = attachments?.first(where: { $0.type == "photo"}),
              let aspect = image.photo?.aspectRatio
        else { return 0.0 }
        return aspect
    }

    var rowsCounter: [NewsTypes] {
        var rowsCounter = [NewsTypes]()

        rowsCounter.append(.header)

        if !text.isEmpty {
            rowsCounter.append(.text)
        }

        if attachmentPhotoUrl != nil {
            rowsCounter.append(.photo)
        }

        rowsCounter.append(.footer)

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
    }

}

// MARK: Attachments
struct Attachments: Codable {
    var type: String
    var photo: PhotosObject?

    enum CodingKeys: String, CodingKey {
        case type
        case photo
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
struct Likes {
    var count: Int
}

extension Likes: Codable {
    enum CodingKeys: String, CodingKey {
        case count
    }
}

// MARK: Reposts
struct Reposts: Codable {
    var count: Int

    enum CodingKeys: String, CodingKey {
        case count
    }
}
