//
//  NetworkGroupsAsyncOperation.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 15.12.2021.
//

import Foundation


final class NetworkGroupsAsyncOperation: AsyncOperationClass {
}

//let url: URL
//let method: HTTPMethod
//let parameters: Parameters
//private(set) var downloadedData: Data?
//
//private var dataTask: URLSessionDataTask?
//
//init(url: URL, method: HTTPMethod = .get, parameters: Parameters = [:]) {
//    self.url = url
//    self.method = method
//    self.parameters = parameters
//}
//
//override func main() {
//    AF.request(url, method: method, parameters: parameters)
//        .responseData { result in
//            guard !self.isCancelled else { return }
//            self.downloadedData = result.data
//            self.state = .finished
//        }
//}


final class ParsingData: Operation {
    
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

