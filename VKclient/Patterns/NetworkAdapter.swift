//
//  NetworkAdapter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 15.01.2022.
//

import Foundation
import Alamofire


struct GroupsAdapterObject {
    
     var name: String
     var photo: String
     var id: Int
}

final class NetworkGroupsAdapter {
    
    private let networkService = NetworkService()

    func getFriendsData(token: String, completion: @escaping ([GroupsObjects]) -> Void) {
        
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
  
          var urlConstructor = URLComponents()
          urlConstructor.scheme = "https"
          urlConstructor.host = "api.vk.com"
          urlConstructor.path = "/method/groups.get"
          urlConstructor.queryItems = [
              URLQueryItem(name: "access_token", value: token),
              URLQueryItem(name: "extended", value: "1"),
              URLQueryItem(name: "fields", value: "photo_100"),
              URLQueryItem(name: "v", value: "5.92"),
          ]
  
          guard let url = urlConstructor.url else { return completion([])}
          var request = URLRequest(url: url)
          request.timeoutInterval = 50.0
          request.setValue(
              "",
              forHTTPHeaderField: "Token")
  
          session.dataTask(with: request) { responseData, urlResponse, error in
              if let response = urlResponse as? HTTPURLResponse {
                  print(response.statusCode)
              }
              guard
                  error == nil,
                  let responseData = responseData
              else { return completion([]) }
              do {
                  let user = try JSONDecoder().decode(GroupsResponse.self,
                                                      from: responseData).response.items
  
                  let groupRealm = user.map { GroupsRealm(groups: $0) }
  
                  DispatchQueue.main.async {
                      completion(user)
                      try? RealmService.save(items: groupRealm)
                  }
  
              } catch {
                  print(error)
              }
          }
          .resume()
    
        func user(from groupsRealm: GroupsRealm) -> GroupsObjects {
            return GroupsObjects(name: groupsRealm.name,
                                 id: groupsRealm.id,
                                 photo: groupsRealm.photo)
        }
    }
    
}
