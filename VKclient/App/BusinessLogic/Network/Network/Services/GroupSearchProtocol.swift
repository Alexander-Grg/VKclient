//
//  GroupSearchProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/17/22.
//

import Foundation
import Combine

struct GroupsSearchKey: InjectionKey {
   static var currentValue: GroupSearchProtocol = GroupSearchService()
}

protocol GroupSearchProtocol: AnyObject {
    func requestGroupsSearch(search: String) -> AnyPublisher<Data, Error>
}

final class GroupSearchService: GroupSearchProtocol {
    
    private let apiProvider = APIProvider<GroupSearchEndpoint>()
    
    func requestGroupsSearch(search: String) -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .groupSearch(search: search))
            .eraseToAnyPublisher()
    }
    
    
}
