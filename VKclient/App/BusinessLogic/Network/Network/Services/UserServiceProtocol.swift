//
//  UserServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/16/22.
//

import Foundation
import Combine

struct UserServiceKey: InjectionKey {
   static var currentValue: UserServiceProtocol = UserService()
}

protocol UserServiceProtocol: AnyObject {
    func requestUsers() -> AnyPublisher<Data, Error>
}

final class UserService: UserServiceProtocol {
    private let apiProvider = APIProvider<FriendsEndpoint>()
    
    func requestUsers() -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .getFriends)
            .eraseToAnyPublisher()
            
    }
}
