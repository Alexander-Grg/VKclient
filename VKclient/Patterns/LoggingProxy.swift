//
//  LoggingProxy.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 28.01.2022.
//

import Foundation

protocol NetworkGroupsServiceInterface {
    func SearchForGroups(token: String,
                         search: String,
                         completion: @escaping ([SearchedObjects]) -> Void)
}

class ProxyNetworkServiceGroupSearch: NetworkGroupsServiceInterface {

    var networkService = NetworkService()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func SearchForGroups(token: String, search: String, completion: @escaping ([SearchedObjects]) -> Void) {
        
        self.networkService.SearchForGroups(token: token , search: search, completion: completion)
        print("called a networkService loading groups method for \(search) request")
    }
}


