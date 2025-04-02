//
//
//  UsersServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 31.03.2025.
//  Copyright © 2025 Alexander Grigoryev. All rights reserved.
//
    
import Combine
import Foundation

struct UsersServiceKey: InjectionKey {
   static var currentValue: UsersServiceProtocol = UsersService()
}

protocol UsersServiceProtocol: AnyObject {
    func requestUsers(Ids: [Int]) -> AnyPublisher<Data, Error>
}

final class UsersService: UsersServiceProtocol {

    private let apiProvider = APIProvider<UserEndpoint>()

    func requestUsers(Ids: [Int]) -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .getUsers(Ids: Ids))
            .eraseToAnyPublisher()
    }
}


