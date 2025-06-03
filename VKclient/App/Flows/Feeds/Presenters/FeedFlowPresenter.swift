//
//  NewsFlowPresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
import Combine
import RealmSwift

enum CurrentFeedType {
    case friendFeed
    case groupFeed
    case newsFeed
    case none
}

enum FeedTypes {
    case photo
    case text
    case header
    case footer
    case video

    func rowsToDisplay() -> UITableViewCell.Type {
        switch self {
        case .photo:
            return FeedTableViewCellPhoto.self
        case .text:
            return FeedTableViewCellText.self
        case .footer:
            return FeedFooterSectionCell.self
        case .header:
            return FeedTableViewHeaderCell.self
        case .video:
            return FeedTableViewCellVideo.self
        }
    }
    
    var cellIdentifiersForRows: String {
        switch self {
        case .photo:
            return FeedTableViewCellPhoto.identifier
        case .text:
            return  FeedTableViewCellText.identifier
        case .footer:
            return FeedFooterSectionCell.identifier
        case .header:
            return FeedTableViewHeaderCell.identifier
        case .video:
            return FeedTableViewCellVideo.identifier
        }
    }
}

protocol FeedFlowInput {
    func updateTableView()
    func updateSpecificPost(at index: Int)
}

protocol FeedFlowOutput {
    var feedPosts: [Post] { get set}
    var type: CurrentFeedType { get }
    var user: UserRealm? { get }
    var feedVideos: [VideoItem] { get set }
    var nextNews: String { get set}
    var isLoading: Bool { get set }
    func loadFeed()
    func loadNextData(startFrom: String, completion: @escaping ([Post], String) -> Void)
    func setLike(itemID: String, ownerID: String)
    func removeLike(itemID: String, ownerID: String)
    func getVideos(ownIDvidIDkey: String, completion: @escaping (VideoItem?) -> Void)
}

final class FeedFlowPresenter {
    @Injected(\.newsService) var newsService
    @Injected(\.likesService) var likesService
    @Injected(\.videosService) var videosService
    @Injected(\.usersService) var usersService
    private var cancellable = Set<AnyCancellable>()
    internal var feedPosts: [Post] = []
    internal var feedVideos: [VideoItem] = []
    internal var nextNews = ""
    internal var isLoading = false
    internal var likesCount = 0
    internal var user: UserRealm?
    internal var communityID: String?
    var type: CurrentFeedType
    var photoTapHandler: ((String) -> Void)?
    weak var viewInput: (UIViewController & FeedFlowInput)?

    init(user: UserRealm? = nil, communityID: String? = nil, type: CurrentFeedType) {
         self.user = user
         self.communityID = communityID
         self.type = type
     }

    
    private func loadPosts() {
        switch self.type {
        case .friendFeed:
            usersService.requestWall(id: String(user?.id ?? 0))
                .decode(type: PostResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("THERE IS NO DATA: \(error.localizedDescription)")
                    case .finished:
                        print("The data is received")
                    }
                }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.feedPosts = value.response.items
                    self.viewInput?.updateTableView()
                }
                )
                .store(in: &cancellable)
        case .groupFeed:
            guard let communityID = communityID, !communityID.isEmpty else
            { return print("There is no valid communityID")}

            usersService.requestWall(id: communityID)
                .decode(type: PostResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("THERE IS NO DATA: \(error.localizedDescription)")
                    case .finished:
                        print("The data is received")
                    }
                }, receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.feedPosts = value.response.items
                    self.viewInput?.updateTableView()
                }
                )
                .store(in: &cancellable)
        case .newsFeed:
            newsService.getNews(startFrom: "", startTime: nil) { [weak self] news, nextFrom in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.feedPosts = news
                    self.nextNews = nextFrom
                    self.viewInput?.updateTableView()
                }
            }
        case .none:
            break
        }
    }
    
    func loadNextData(startFrom: String, completion: @escaping ([Post], String) -> Void) {
        if user?.id != nil {
            return
        } else {
            newsService.getNews(startFrom: startFrom, startTime: nil) { newNews, nextFrom in
                DispatchQueue.main.async {
                    completion(newNews, nextFrom)
                }
            }
        }
    }

    func didTapPhoto(with id: String) {
        photoTapHandler?(id)
    }

    func setLike(itemID: String, ownerID: String) {
        likesService.setLike(type: "post", itemID: itemID, ownerID: ownerID)
            .decode(type: LikesResponseAPI.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("The like method is finished")
                case .failure(let error):
                    print("The error appeared during the set like method \(error)")
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.likesCount = value.response.likes
                if let postIndex = self.findPostIndex(itemID: itemID, ownerID: ownerID) {
                    DispatchQueue.main.async {
                        let oldModel = self.feedPosts[postIndex].likes
                        self.feedPosts[postIndex].likes = Likes(canLike: 0, count: value.response.likes, userLikes: oldModel?.userLikes, canPublish: oldModel?.canPublish, repostDisabled: oldModel?.repostDisabled)

                        self.viewInput?.updateSpecificPost(at: postIndex)
                    }
                }
            }).store(in: &cancellable)
    }

    func removeLike(itemID: String, ownerID: String) {
        likesService.removeLike(type: "post", itemID: itemID, ownerID: ownerID)
            .decode(type: LikesResponseAPI.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("The remove like method is finished")
                case .failure(let error):
                    print("The error appeared during the like removal method \(error)")
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.likesCount = value.response.likes
                if let postIndex = self.findPostIndex(itemID: itemID, ownerID: ownerID) {
                    DispatchQueue.main.async {
                        let oldModel = self.feedPosts[postIndex].likes
                        self.feedPosts[postIndex].likes = Likes(canLike: 1, count: value.response.likes, userLikes: oldModel?.userLikes, canPublish: oldModel?.canPublish, repostDisabled: oldModel?.repostDisabled)

                        self.viewInput?.updateSpecificPost(at: postIndex)
                    }
                }
            }).store(in: &cancellable)
    }

    private func findPostIndex(itemID: String, ownerID: String) -> Int? {
        guard let targetItemID = Int(itemID), let targetOwnerID = Int(ownerID) else { return nil }

        return feedPosts.firstIndex { post in
            let postID = post.postID ?? post.postWallId
            let sourceID = post.sourceId ?? post.fromID
            return postID == targetItemID && sourceID == targetOwnerID
        }
    }

    func isLiked(itemID: String, ownerID: String) -> Bool {
        var isThisItemLiked: Bool = false
        likesService.isLiked(type: "post", itemID: itemID, ownerID: ownerID)
            .decode(type: Likes.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("The isLike method is finished")
                case .failure(let error):
                    print("The error appeared during the isLike method \(error)")
                }}, receiveValue: {[weak self] value in
                    guard let self = self else { return }
                    isThisItemLiked = value.canLike == 1 ? true : false
                }).store(in: &cancellable)
        
        return isThisItemLiked
    }

    func getVideos(ownIDvidIDkey: String, completion: @escaping (VideoItem?) -> Void) {
        videosService.requestVideos(ownIDvidIDkey: ownIDvidIDkey)
            .decode(type: VideoApiResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    print("Get videos method is finished")
                case .failure(let error):
                    print("The error appeared during the get videos method \(error)")
                    completion(nil)
                }
            }, receiveValue: { value in
                completion(value.response.items.first)
            })
            .store(in: &cancellable)
    }
}

extension FeedFlowPresenter: FeedFlowOutput {
    func loadFeed() {
        self.loadPosts()
    }
}
