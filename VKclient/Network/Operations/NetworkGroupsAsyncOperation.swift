//
//  NetworkGroupsAsyncOperation.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 15.12.2021.
//

import Foundation

final class NetworkGroupsAsyncOperation: AsyncOperationClass {
    
    let networkService = NetworkService()
    let url: URL
    private(set) var data: Data?
    private var dataTask: URLSessionDataTask?
    
    init(url: URL) {
        self.url = url
    }
    
    override func main() {
        networkService.urlConstructor.path += "groups.get"
        networkService.urlConstructor.queryItems?.append(
            URLQueryItem(
                name: "extended",
                value: "1"))
        networkService.urlConstructor.queryItems?.append(
            URLQueryItem(
                name: "fields",
                value: "photo_100"))
        
        guard let url = networkService.urlConstructor.url
        else { return }
        
        networkService.session.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print("STATUS CODE: \(response.statusCode)")
            }
            guard
                error == nil,
                !self.isCancelled
            else { return }
            self.data = data
            self.state = .finished
        }
    }
}

final class ParsingData: Operation {
    
    var outputData: [GroupsObjects]?
    
    private func parsingData(completion: @escaping ([GroupsObjects]) -> Void) {
        guard let downloadData = dependencies.first as? NetworkGroupsAsyncOperation,
              let responseData = downloadData.data else { return }
        do {
            let parsedGroups = try JSONDecoder().decode(GroupsResponse.self, from: responseData).response.items
            completion(parsedGroups)
        } catch {
            print(error)
        }
        
    }
    
    override func main() {
        parsingData { parsedData in
            self.outputData = parsedData
            
        }
    }
    
}

final class SavingGroupsToRealmAsyncOperation: Operation {
    
    override func main() {
        guard let parsedData = dependencies.first as? ParsingData,
              let data = parsedData.outputData
        else { return }
        let groupsRealm = data.map {GroupsRealm(groups: $0)}
        try? RealmService.save(items: groupsRealm)
        
        
    }
    
}

