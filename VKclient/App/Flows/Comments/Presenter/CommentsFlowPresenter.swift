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
}

protocol CommentsFlowViewInput {
    func reloadData()
}

final class CommentsFlowPresenter {
    private var cancellable = Set<AnyCancellable>()
    @Injected(\.commentsService) var commentsService
    weak var viewInput: (UIViewController & CommentsFlowViewInput)?
    let ownerID: Int?
    let postID: Int?
    var comments: [CommentModel] = []
    var profiles: [CommentUserModel] = []
    var groups: [CommentGroupModel] = []


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
