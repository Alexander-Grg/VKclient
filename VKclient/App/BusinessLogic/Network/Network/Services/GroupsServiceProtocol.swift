//
//  GroupsServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/16/22.
//

import Foundation
import Combine

protocol GroupsServiceProtocol {
    func requestGroups() -> AnyPublisher<Data, Error>
}

final class GroupsService: GroupsServiceProtocol {
    private let apiProvider = APIProvider<GroupsEndpoint>()
    
    func requestGroups() -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .getGroups)
            .eraseToAnyPublisher()
    }
}