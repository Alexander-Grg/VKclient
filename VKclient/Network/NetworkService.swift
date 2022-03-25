//
//  NetworkService.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 02.10.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

final class NetworkService: NetworkGroupsServiceInterface {
    
    enum RequestErrors: String, Error {
        case invalidUrl
        case decoderError
        case requestFailed
        case unknownError
        case realmError
    }

    let dispatchGroup = DispatchGroup()
    // MARK: Network configuration/session
    let session = URLSession.shared
    var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        constructor.path = "/method/"
        constructor.queryItems = [
            URLQueryItem(
                name: "access_token",
                         value: Session.instance.token),
            URLQueryItem(
                name: "v",
                         value: "5.92")
        ]
        return constructor
    }()
    
    func loadFriends(completion: @escaping (Result<[UserRealm], RequestErrors>) -> Void) {

        urlConstructor.path += "friends.get"
        urlConstructor.queryItems?.append(
            URLQueryItem(
            name: "order",
            value: "random"))
        urlConstructor.queryItems?.append(
            URLQueryItem(
            name: "fields",
            value: "nickname, photo_100"))
     
        guard let url = urlConstructor.url
        else { return completion(.failure(.invalidUrl))}
        
        
//
//        var request = URLRequest(url: url)
//        request.timeoutInterval = 50.0
//        request.setValue(
//            "",
//            forHTTPHeaderField: "Token")
        session.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print("STATUS CODE: \(response.statusCode)")
            }
            
            guard
                error == nil,
                let responseData = data else
            { return completion(.failure(.requestFailed))}
            
            do {
                let user = try JSONDecoder().decode(UserResponse.self,
                                                    from: responseData).response.items
                
                let groupRealm = user.map { UserRealm(user: $0)
                }
                DispatchQueue.main.async {
                    completion(.success(groupRealm))
                }
            } catch {
                print(completion(.failure(.decoderError)))
            }
        }
        .resume()
    }
    
    
    
    // MARK: Load photos method
    func loadPhotos(token: String, ownerID: String)
    {
        urlConstructor.path += "photos.get"
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
                let photos = try JSONDecoder().decode(PhotosResponse.self,
                                                      from: responseData).response.items
                
                let groupRealm = photos.map { RealmPhotos(photos: $0)
                }
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
        urlConstructor.path += "groups.search"
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
    
    
    func loadNewsFeed(startFrom: String = "", startTime: Double? = nil, _ completion: @escaping ([News], String) -> Void) {

        urlConstructor.path += "newsfeed.get"
//        var params =
        urlConstructor.queryItems =  [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "start_from", value: startFrom),
            URLQueryItem(name: "filters", value: "post, photo"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "v", value: "5.92"),
        ]

//        if let startTime = startTime {
//            params.append(URLQueryItem(name: "start_time", value: "\(startTime)"))
//               }

//        urlConstructor.queryItems = params

        guard let url = urlConstructor.url else { return completion([], "")}
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
            else { return completion([], "") }
//            var posts: [News] = []
//            var profiles: [User] = []
//            var groups: [Community] = []
            do {
                let nextFrom = try JSONDecoder().decode(Newsfeed.self, from: responseData).nextFrom
                let postJSON = try JSONDecoder().decode(Newsfeed.self, from: responseData).items
//                posts = postJSON
                let userJSON = try JSONDecoder().decode(Newsfeed.self, from: responseData).profiles
//                profiles = userJSON
                let groupsJSON = try JSONDecoder().decode(Newsfeed.self, from: responseData).groups
//                groups = groupsJSON

                self.dispatchGroup.notify(queue: DispatchQueue.global()) {
                    let newsWithSources = postJSON.compactMap { posts -> News? in
                        if posts.sourceId > 0 {
                            let news = posts
                            guard let newsID = userJSON.first(where: { $0.id == posts.sourceId})
                            else { return nil }
                            news.urlProtocol = newsID
                            return news
                        } else {
                            let news = posts
                            guard let newsID = groupsJSON.first(where: { -$0.id == posts.sourceId})
                            else { return nil }
                            news.urlProtocol = newsID
                            return news
                        }
                    }
                    DispatchQueue.main.async {
                        completion(newsWithSources, nextFrom)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
    //
    //    func loadNewsFeed(startFrom: String = "", startTime: Double? = nil, _ completion: @escaping ([PostNews], String) -> Void) {
    //        let path = "/method/newsfeed.get"
    //
    //        var params: Parameters = [
    //            "access_token": Session.instance.token,
    //            "v": "5.92",
    //            "filters": "post, photo",
    //            "count": "10",
    //            "start_from": startFrom
    //        ]
    //
    //        if let startTime = startTime {
    //            params["start_time"] = startTime
    //        }
    //
    //        AF.request(NetworkService.baseUrl + path,
    //                   method: .get,
    //                   parameters: params)
    //            .responseData { response in
    //                switch response.result {
    //                case .success(let data):
    //
    //                    var posts: [PostNews] = []
    //                    var profiles: [UserNews] = []
    //                    var groups: [GroupNews] = []
    //                    let nextFrom = JSON(data)["response"]["next_from"].stringValue
    //
    //                    DispatchQueue.global().async(group: self.dispatchGroup, qos: .userInitiated) {
    //                        let postJSONs = JSON(data)["response"]["items"].arrayValue
    //                        posts = postJSONs.compactMap(PostNews.init)
    //                    }
    //
    //                    DispatchQueue.global().async(group: self.dispatchGroup, qos: .userInitiated) {
    //                        let profileJSONs = JSON(data)["response"]["profiles"].arrayValue
    //                        profiles = profileJSONs.compactMap { UserNews($0) }
    //                    }
    //
    //                    DispatchQueue.global().async(group: self.dispatchGroup, qos: .userInitiated) {
    //                        let groupJSONs = JSON(data)["response"]["groups"].arrayValue
    //                        groups = groupJSONs.compactMap { GroupNews($0) }
    //                    }
    //
    //                    self.dispatchGroup.notify(queue: DispatchQueue.global()) {
    //                        let newsWithSources = posts.compactMap { posts -> PostNews? in
    //                            if posts.sourceID > 0 {
    //                                let news = posts
    //                                guard let newsID = profiles.first(where: { $0.id == posts.sourceID})
    //                                else { return nil }
    //                                news.urlProtocol = newsID
    //                                return news
    //                            } else {
    //                                let news = posts
    //                                guard let newsID = groups.first(where: { -$0.id == posts.sourceID })
    //                                else { return nil }
    //                                news.urlProtocol = newsID
    //                                return news
    //                            }
    //                        }
    //                        DispatchQueue.main.async {
    //                            completion(newsWithSources, nextFrom)
    //                        }
    //                    }
    //
    //                case .failure(let error):
    //                    print(error)
    //                }
    //            }
    //    }
    //}
