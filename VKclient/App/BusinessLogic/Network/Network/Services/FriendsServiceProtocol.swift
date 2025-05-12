//
//  UserServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/16/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation
import Combine

struct FriendsServiceKey: InjectionKey {
   static var currentValue: FriendsServiceProtocol = FriendsService()
}

protocol FriendsServiceProtocol: AnyObject {
    func requestUsers() -> AnyPublisher<Data, Error>
}

final class FriendsService: FriendsServiceProtocol {
    private let apiProvider = APIProvider<FriendsEndpoint>()
    
    func requestUsers() -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .getFriends)
            .eraseToAnyPublisher()
    }
}
