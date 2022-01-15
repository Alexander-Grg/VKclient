//
//  NetworkService.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 02.10.2021.
//

import Foundation
import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import PromiseKit

enum PromiseErrors: Error {
    case urlError, dataTaskError, decoderError
}
final class NetworkService {
    
    private let url: String = "https://api.vk.com/method"
    private let apiVersion: String = "5.92"
    let dispatchGroup = DispatchGroup()
    private static let baseUrl = "https://api.vk.com"
    // MARK: Network configuration/session
    private let session = URLSession.shared
    var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        return constructor
    }()

//    MARK: DataTaskRequest
    private func dataTaskRequest(_ request: URLRequest) -> Promise<Data> {
        return Promise { seal in
            session.dataTask(with: request) { responseData, urlResponse, error in
                if let response = urlResponse as? HTTPURLResponse {
                    print(response.statusCode)
                }
                guard
                    error == nil,
                    let responseData = responseData else
                    { return seal.reject(PromiseErrors.dataTaskError) }
                seal.fulfill(responseData)
            } .resume()
        }
    }
    
    
//    MARK: Load groups with AF method
//    func loadGroups(token: String)
//       //                    completionHandler: @escaping ((Swift.Result<[GroupsObjects], Error>) -> Void))
//       {
//           let path = "https://api.vk.com/method/groups.get"
//           let params: Parameters = [
//               "access_token": token,
//               "extended": "1",
//               "fields": "photo_100",
//               "v": "5.92"
//           ]
//           
//           AF.request(NetworkService.baseUrl + path, method: .get, parameters: params).responseData { response in
//               switch response.result {
//               case let .success(data):
//                   do {
//                       let groupsResponse = try JSONDecoder().decode(GroupsResponse.self, from: data)
//                       let groups = groupsResponse.response.items
//                       //                        completionHandler(.success(groups))
//                       let groupsRealm = groups.map { GroupsRealm(groups: $0)}
//                       DispatchQueue.main.async {
//                           try? RealmService.save(items: groupsRealm)
//                       }
//                   } catch {
//                       //                        completionHandler(.failure(error))
//                       print(error)
//                   }
//               case let .failure(error):
//                   print(error)
//                   //                    completionHandler(.failure(error))
//               }
//           }
//       }
           
    
    //    MARK: Load groups method URL SESSION
//    func loadGroups(
//        token: String)
//    {
//        let configuration = URLSessionConfiguration.default
//        let session =  URLSession(configuration: configuration)
//
//        var urlConstructor = URLComponents()
//        urlConstructor.scheme = "https"
//        urlConstructor.host = "api.vk.com"
//        urlConstructor.path = "/method/groups.get"
//        urlConstructor.queryItems = [
//            URLQueryItem(name: "access_token", value: token),
//            URLQueryItem(name: "extended", value: "1"),
//            URLQueryItem(name: "fields", value: "photo_100"),
//            URLQueryItem(name: "v", value: "5.92"),
//        ]
//
//        guard let url = urlConstructor.url else { return }
//        var request = URLRequest(url: url)
//        request.timeoutInterval = 50.0
//        request.setValue(
//            "",
//            forHTTPHeaderField: "Token")
//
//        session.dataTask(with: request) { responseData, urlResponse, error in
//            if let response = urlResponse as? HTTPURLResponse {
//                print(response.statusCode)
//            }
//            guard
//                error == nil,
//                let responseData = responseData
//            else { return }
//            do {
//                let user = try JSONDecoder().decode(GroupsResponse.self,
//                                                    from: responseData).response.items
//
//                let groupRealm = user.map { GroupsRealm(groups: $0) }
//
//                DispatchQueue.main.async {
//                    try? RealmService.save(items: groupRealm)
//                }
//
//            } catch {
//                print(error)
//            }
//        }
//        .resume()
//    }
    
    
    
    func loadFriends(
        token: String) -> Promise<[UserRealm]>
    {
        return Promise { seal in
            urlConstructor.path = "/method/friends.get"
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: token),
                URLQueryItem(name: "order", value: "random"),
                URLQueryItem(name: "fields", value: "nickname, photo_100"),
                URLQueryItem(name: "v", value: "5.92"),
            ]
            
            guard let url = urlConstructor.url else { return }
            var request = URLRequest(url: url)
            request.timeoutInterval = 50.0
            request.setValue(
                "",
                forHTTPHeaderField: "Token")
            dataTaskRequest(request)
                .map(on: .global()) { data in
                 let user = try JSONDecoder().decode(UserResponse.self,from: data).response.items
                 let groupRealm = user.map { UserRealm(user: $0) }
                    try? RealmService.save(items: groupRealm)
                }
                .catch { _ in seal.reject(PromiseErrors.decoderError)}
    }
        }

    
    
    // MARK: Load photos method
    func loadPhotos(token: String, ownerID: String)
    //                        completion: @escaping ([PhotosObject]) -> Void)
    {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/photos.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "rev", value: "1"),
            URLQueryItem(name: "owner_id", value: ownerID),
            URLQueryItem(name: "album_id", value: "profile"),
            URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "photo_sizes", value: "0"),
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
            guard
                error == nil,
                let responseData = responseData
            else { return }
            do {
                let user = try JSONDecoder().decode(PhotosResponse.self,
                                                    from: responseData).response.items
                
                let groupRealm = user.map { RealmPhotos(photos: $0) }
                DispatchQueue.main.async {
                    try? RealmService.save(items: groupRealm)
                }
                
                
            } catch {
                print(error)
            }
        }
        .resume()
    }
    
    //    MARK: Search for groups method
    func SearchForGroups(token: String,
                         search: String,
                         completion: @escaping ([SearchedObjects]) -> Void)
    {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/groups.search"
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "sort", value: "6"),
            URLQueryItem(name: "type", value: "group"),
            URLQueryItem(name: "q", value: search),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "v", value: "5.92"),
        ]
        
        guard let url = urlConstructor.url else { return completion([])}
        var request = URLRequest(url: url)
        request.timeoutInterval = 50.0
        request.setValue("", forHTTPHeaderField: "Token")
        
        session.dataTask(with: request) { responseData, urlResponse, error in
            if let response = urlResponse as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard
                error == nil,
                let responseData = responseData
            else { return completion([]) }
            do {
                let user = try JSONDecoder().decode(SearchResponse.self,
                                                    from: responseData).response.items
                DispatchQueue.main.async {
                    completion(user)
                    print(user)
                }
            } catch {
                print(error)
            }
        }
        .resume()
    }
    
    func loadNewsFeed(startFrom: String = "", startTime: Double? = nil, _ completion: @escaping ([PostNews], String) -> Void) {
        let path = "/method/newsfeed.get"
        
        var params: Parameters = [
            "access_token": Session.instance.token,
            "v": "5.92",
            "filters": "post, photo",
            "count": "10",
            "start_from": startFrom
        ]
        
        if let startTime = startTime {
            params["start_time"] = startTime
        }
        
        AF.request(NetworkService.baseUrl + path,
                   method: .get,
                   parameters: params)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    
                    var posts: [PostNews] = []
                    var profiles: [UserNews] = []
                    var groups: [GroupNews] = []
                    let nextFrom = JSON(data)["response"]["next_from"].stringValue

                    DispatchQueue.global().async(group: self.dispatchGroup, qos: .userInitiated) {
                        let postJSONs = JSON(data)["response"]["items"].arrayValue
                        posts = postJSONs.compactMap(PostNews.init)
                    }
                    
                    DispatchQueue.global().async(group: self.dispatchGroup, qos: .userInitiated) {
                        let profileJSONs = JSON(data)["response"]["profiles"].arrayValue
                        profiles = profileJSONs.compactMap { UserNews($0) }
                    }
                    
                    DispatchQueue.global().async(group: self.dispatchGroup, qos: .userInitiated) {
                        let groupJSONs = JSON(data)["response"]["groups"].arrayValue
                        groups = groupJSONs.compactMap { GroupNews($0) }
                    }
                    
                    self.dispatchGroup.notify(queue: DispatchQueue.global()) {
                        let newsWithSources = posts.compactMap { posts -> PostNews? in
                            if posts.sourceID > 0 {
                                let news = posts
                                guard let newsID = profiles.first(where: { $0.id == posts.sourceID})
                                else { return nil }
                                news.urlProtocol = newsID
                                return news
                            } else {
                                let news = posts
                                guard let newsID = groups.first(where: { -$0.id == posts.sourceID })
                                else { return nil }
                                news.urlProtocol = newsID
                                return news
                            }
                        }
                        DispatchQueue.main.async {
                            completion(newsWithSources, nextFrom)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
}


