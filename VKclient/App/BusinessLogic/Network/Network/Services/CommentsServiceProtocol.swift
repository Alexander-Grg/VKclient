//
//
//  CommentsServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 30.03.2025.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//
    
import Combine
import Foundation

struct CommentsServiceKey: InjectionKey {
   static var currentValue: CommentsServiceProtocol = CommentsService()
}

protocol CommentsServiceProtocol: AnyObject {
    func requestComments(ownerID: Int, postID: Int) -> AnyPublisher<Data, Error>
}

final class CommentsService: CommentsServiceProtocol {

    private let apiProvider = APIProvider<CommentsEndpoint>()

    func requestComments(ownerID: Int, postID: Int) -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .getNewsComments(ownerID: ownerID, postID: postID))
            .eraseToAnyPublisher()
    }
}

