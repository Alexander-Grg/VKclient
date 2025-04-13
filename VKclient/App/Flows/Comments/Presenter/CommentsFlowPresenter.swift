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
    var orderedCommentUserPairs: [(comment: CommentModel, user: UserModel)] { get }
    func loadData()
}

protocol CommentsFlowViewInput {
    func reloadData()
}

final class CommentsFlowPresenter {
    private var cancellable = Set<AnyCancellable>()
    @Injected(\.commentsService) var commentsService
    @Injected(\.usersService) var usersService
    weak var viewInput: (UIViewController & CommentsFlowViewInput)?
    let ownerID: Int?
    let postID: Int?
    var finalComments: [CommentModel] = []
    var comments: [CommentModel] = []
    var profiles: [UserModel] = []
    var userIDs: [Int] = []
    var orderedCommentUserPairs: [(comment: CommentModel, user: UserModel)] = []
    var commentUserDict: [CommentModel: UserModel] = [:]

    init(ownerID: Int?, postID: Int?) {
        self.ownerID = ownerID
        self.postID = postID
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
                self.getUsers()
            }
            )
            .store(in: &cancellable)
    }

    func commentsToIDs(comments: [CommentModel]) {
        guard !comments.isEmpty else { return }
        userIDs = comments.map { $0.fromID }
    }

    func getUsers() {
          self.commentsToIDs(comments: self.comments)
          guard !userIDs.isEmpty else { return }

          usersService.requestUsers(Ids: self.userIDs)
              .decode(type: UserModelResponse.self, decoder: JSONDecoder())
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
                  self.buildCommentUserDictionary(users: value.response)
                  self.viewInput?.reloadData()
              })
              .store(in: &cancellable)
      }

    private func buildCommentUserDictionary(users: [UserModel]) {
        self.commentUserDict = [:]

        for comment in self.comments {
            if let user = users.first(where: { $0.id == comment.fromID }) {
                self.commentUserDict[comment] = user
                self.orderedCommentUserPairs.append((comment: comment, user: user))
            }
        }
    }
}

extension CommentsFlowPresenter: CommentsFlowViewOutput {
    func loadData() {
        self.getComments(ownerID: ownerID, postID: postID)
    }
}
