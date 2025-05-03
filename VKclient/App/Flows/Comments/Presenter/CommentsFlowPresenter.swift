//
//
//  CommentsFlowPresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.03.2025.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
import Combine

protocol CommentsFlowViewOutput {
    var comments: [CommentModel] { get }
    func getDisplayName(for fromID: Int) -> String
    func loadData()
    func setLike(itemID: String, ownerID: String)
    func removeLike(itemID: String, ownerID: String)
}

protocol CommentsFlowViewInput {
    func reloadData()
    func updateSpecificPost(at index: Int)
}

final class CommentsFlowPresenter {
    private var cancellable = Set<AnyCancellable>()
    @Injected(\.commentsService) var commentsService
    @Injected(\.likesService) var likesService
    weak var viewInput: (UIViewController & CommentsFlowViewInput)?
    let ownerID: Int?
    let postID: Int?
    var comments: [CommentModel] = []
    var profiles: [CommentUserModel] = []
    var groups: [CommentGroupModel] = []
    internal var likesCount = 0


    init(ownerID: Int?, postID: Int?) {
        self.ownerID = ownerID
        self.postID = postID
    }

    func setLike(itemID: String, ownerID: String) {
        likesService.setLike(type: "comment", itemID: itemID, ownerID: ownerID)
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
                if let commentIndex = self.findCommentIndex(itemID: itemID) {
                    DispatchQueue.main.async {
                        let oldModel = self.comments[commentIndex].likes
                        self.comments[commentIndex].likes =  CommentLikes(canLike: 0, count: value.response.likes, userLikes: oldModel?.userLikes ?? 0)
                        self.viewInput?.updateSpecificPost(at: commentIndex)
                    }
                }
            }).store(in: &cancellable)
    }

    func removeLike(itemID: String, ownerID: String) {
        likesService.removeLike(type: "comment", itemID: itemID, ownerID: ownerID)
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
                if let commentIndex = self.findCommentIndex(itemID: itemID) {
                    DispatchQueue.main.async {
                        let oldModel = self.comments[commentIndex].likes
                        self.comments[commentIndex].likes =  CommentLikes(canLike: 1, count: value.response.likes, userLikes: oldModel?.userLikes ?? 0)
                        self.viewInput?.updateSpecificPost(at: commentIndex)
                    }
                }
            }).store(in: &cancellable)
    }

    private func findCommentIndex(itemID: String) -> Int? {
        return comments.firstIndex { comment in
            return comment.id == Int(itemID)
        }
    }

    func getComments(ownerID: Int?, postID: Int?) {
        guard let ownerID = ownerID, let postID = postID else { return }
        commentsService.requestComments(ownerID: ownerID, postID: postID)
            .decode(type: CommentApiResponse.self, decoder: JSONDecoder())
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
                self.comments = value.response.items
                self.profiles = value.response.profiles
                self.groups = value.response.groups
                self.viewInput?.reloadData()
            }
            )
            .store(in: &cancellable)
    }

    func getDisplayName(for fromID: Int) -> String {
        if fromID > 0 {
            if let profile = profiles.first(where: { $0.id == fromID }) {
                return "\(profile.firstName) \(profile.lastName)"
            }
        } else {
            if let group = groups.first(where: { $0.id == fromID }) {
                return group.name
            }
        }
        return "Unknown"
    }
}

extension CommentsFlowPresenter: CommentsFlowViewOutput {
    func loadData() {
        self.getComments(ownerID: ownerID, postID: postID)
    }
}
