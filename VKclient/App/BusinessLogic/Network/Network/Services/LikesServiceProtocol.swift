//
//  LikesServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 13/12/24.
//

import Combine
import Foundation

struct LikesServiceKey: InjectionKey {
   static var currentValue: LikesServiceProtocol = LikesService()
}

protocol LikesServiceProtocol: AnyObject {
    func setLike(type: String, itemID: String, ownerID: String) -> AnyPublisher<Data, Error>
    func removeLike(type: String, itemID: String, ownerID: String) -> AnyPublisher<Data, Error>
    func isLiked(type: String, itemID: String, ownerID: String) -> AnyPublisher<Data, Error>
}

final class LikesService: LikesServiceProtocol {
    private let apiProvider = APIProvider<LikesEndpoint>()

    func setLike(type: String, itemID: String, ownerID: String) -> AnyPublisher<Data, any Error> {
        return apiProvider.getData(from: .setLike(type: type , itemID: itemID, ownerID: ownerID))
            .eraseToAnyPublisher()
    }
    
    func removeLike(type: String, itemID: String, ownerID: String) -> AnyPublisher<Data, any Error> {
        return apiProvider.getData(from: .removeLike(type: type, itemID: itemID, ownerID: ownerID))
    }
    
    func isLiked(type: String, itemID: String, ownerID: String) -> AnyPublisher<Data, any Error> {
        return apiProvider.getData(from: .isLiked(type: type, itemID: itemID, ownerID: ownerID))
            .eraseToAnyPublisher()
    }
}
