//
//  GroupsServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/16/22.
//

import Foundation
import Combine

 struct GroupsServiceKey: InjectionKey {
    static var currentValue: GroupsServiceProtocol = GroupsService()
}

struct GroupsActionsKey: InjectionKey {
   static var currentValue: GroupsActionProtocol = GroupsActionsService()
}

protocol GroupsServiceProtocol: AnyObject {
    func requestGroups() -> AnyPublisher<Data, Error>
}

protocol GroupsActionProtocol: AnyObject {
    func requestGroupsJoin(id: Int) -> AnyPublisher<Data, Error>
    func requestGroupsLeave(id: Int) -> AnyPublisher<Data, Error>
}

final class GroupsService: GroupsServiceProtocol {
    private let apiProvider = APIProvider<GroupsEndpoint>()
    
    func requestGroups() -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .getGroups)
            .eraseToAnyPublisher()
    }
}

final class GroupsActionsService: GroupsActionProtocol {
    private let apiProvider = APIProvider<GroupsEndpoint>()

    func requestGroupsJoin(id: Int) -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .joinGroup(groupID: id))
            .eraseToAnyPublisher()
    }

    func requestGroupsLeave(id: Int) -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .joinGroup(groupID: id))
            .eraseToAnyPublisher()
    }
}
