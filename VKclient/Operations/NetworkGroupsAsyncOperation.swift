//
//  NetworkGroupsAsyncOperation.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 15.12.2021.
//

import Foundation


final class NetworkGroupsAsyncOperation: AsyncOperationClass {
   
    var token: String
    var responseData: Data?

    init (token: String) {
        self.token = token
    }
    private let session = URLSession.shared
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        return constructor
    }()
    
     func downloadGroupsData(token: String, completion: @escaping (Data?) -> Void) {
        
        urlConstructor.path = "/method/groups.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "photo_100"),
            URLQueryItem(name: "v", value: "5.92"),
        ]
        
        guard let url = urlConstructor.url else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 50.0
        request.setValue(
            "",
            forHTTPHeaderField: "Token")
        
        session.dataTask(with: request) { responseData, urlResponse, error in
            if let response = urlResponse as? HTTPURLResponse {
                print(response.statusCode)
            }
    
     }
            guard let responseData = responseData
            else { return }
         completion(responseData)
     
     }

    
    override func main() {
        downloadGroupsData(token: token) { [weak self] response in
            self?.responseData = response
            self?.state = .finished
        }
    }
        
    }


final class ParsingData: AsyncOperationClass {
    
    var outputData: [GroupsObjects]?
    
    private func parsingData(completion: @escaping ([GroupsObjects]) -> Void) {
        guard let downloadData = dependencies.first as? NetworkGroupsAsyncOperation,
              let responseData = downloadData.responseData else { return }
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
            self.state = .finished
        }
    }

}

final class SavingGroupsToRealmAsyncOperation: AsyncOperationClass {

    override func main() {
        guard let parsedData = dependencies.first as? ParsingData,
              let data = parsedData.outputData
        else { return }
        let groupsRealm = data.map {GroupsRealm(groups: $0)}
        try? RealmService.save(items: groupsRealm)
        
        self.state = .finished
}

}

