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
    var comments: [Comment] { get }
    func viewDidLoad()
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
    var comments: [Comment] = []

    init(ownerID: Int?, postID: Int?) {
        self.ownerID = ownerID
        self.postID = postID
    }

    func getComments(ownerID: Int?, postID: Int?) {
        guard let ownerID = ownerID, let postID = postID else { return }
        commentsService.requestComments(ownerID: ownerID, postID: postID)
            .decode(type: CommentsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("THERE IS NO DATA: \(error.localizedDescription)")
//                    self.alertOfNoData()
                case .finished:
                    print("The data is received")
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.comments = value.response.items
                self.viewInput?.reloadData()
            }
            )
            .store(in: &cancellable)
    }

    func getUser() {
//        MARK: There is no Name and surname in comments, I need to get user by ID.
    }
}

extension CommentsFlowPresenter: CommentsFlowViewOutput {
    func viewDidLoad() {
        self.getComments(ownerID: ownerID, postID: postID)
    }
}
