//
//  NetworkService.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 02.10.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

final class NetworkService {
    
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
    
    func loadFriends(
        completion: @escaping (Result<[UserObject], RequestErrors>) -> Void)
    {
        
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
                try RealmService.save(items: groupRealm)
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } catch {
                print(completion(.failure(.decoderError)))
            }
        }
        .resume()
    }
    
    
    
    // MARK: Load photos method
    func loadPhotos(
        ownerID: String,
        completion: @escaping (Result<[RealmPhotos], RequestErrors>) -> Void)
    {
        urlConstructor.path += "photos.get"
        urlConstructor.queryItems?.append(
            URLQueryItem(
                name: "rev",
                value: "1"))
        urlConstructor.queryItems?.append(
            URLQueryItem(
                name: "owner_id",
                value: ownerID))
        urlConstructor.queryItems?.append(
            URLQueryItem(
                name: "album_id",
                value: "profile"))
        urlConstructor.queryItems?.append(
            URLQueryItem(
                name: "offset",
                value: "0"))
        urlConstructor.queryItems?.append(
            URLQueryItem(
                name: "photo_sizes",
                value: "0"))
        
        guard let url = urlConstructor.url else {
            return completion(.failure(.invalidUrl)) }
        
        session.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard
                error == nil,
                let responseData = data
            else { return completion(.failure(.requestFailed))}
            do {
                let photos = try JSONDecoder().decode(PhotosResponse.self,
                                                      from: responseData).response.items
                
                let groupRealm = photos.map { RealmPhotos(photos: $0)
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
    
    func fetchingGroups(
        completion: @escaping (Result<[GroupsObjects], RequestErrors>) -> Void)
    {
        urlConstructor.path += "groups.get"
        urlConstructor.queryItems?.append(
            URLQueryItem(
                name: "extended",
                value: "1"))
        urlConstructor.queryItems?.append(
            URLQueryItem(
                name: "fields",
                value: "photo_100"))
        
        guard let URL = urlConstructor.url else
        { return completion(.failure(.invalidUrl)) }
   
        
        session.dataTask(with: URL) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            
            guard error == nil,
                  let responseData = data
            else {
                return completion(.failure(.requestFailed)) }

                do {
                    let groups = try JSONDecoder().decode(GroupsResponse.self, from: responseData).response.items
                    
                    let realmGroups = groups.map { GroupsRealm(groups: $0)}

                    DispatchQueue.main.async {
                        try? RealmService.save(items: realmGroups)
                        completion(.success(groups))
                    }
                } catch {
                    print(completion(.failure(.realmError)))
                }
        } .resume()
    }
    //    MARK: Search for groups method
    func SearchForGroups(search: String,
                         completion: @escaping ([SearchedObjects]) -> Void)
    {
        urlConstructor.path += "groups.search"

        urlConstructor.queryItems?.append(
            URLQueryItem(
                name: "sort",
                value: "6"))
        urlConstructor.queryItems?.append(
            URLQueryItem(
                name: "type",
                value: "group"))
        urlConstructor.queryItems?.append(
            URLQueryItem(
                name: "q",
                value: search))
        urlConstructor.queryItems?.append(
            URLQueryItem(
                name: "count",
                value: "20"))
        
        guard let url = urlConstructor.url else {
            return completion([])}
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 50.0
        request.setValue("", forHTTPHeaderField: "Token")
    
        session.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard
                error == nil,
                let responseData = data
            else { return completion([]) }
            do {
                let groupsData = try JSONDecoder().decode(SearchResponse.self,
                                                    from: responseData).response.items
                DispatchQueue.main.async {
                    completion(groupsData)
                }
            } catch {
                print(error)
            }
        }
        .resume()
    }
    
    
    func loadNewsFeed(startFrom: String = "", startTime: Double? = nil, _ completion: @escaping (Result<[News], RequestErrors>, Result<String, RequestErrors>) -> Void) {

        urlConstructor.path += "newsfeed.get"
        urlConstructor.queryItems?.append(URLQueryItem(name: "start_from", value: startFrom))
        urlConstructor.queryItems?.append(URLQueryItem(name: "filters", value: "post, photo"))
        urlConstructor.queryItems?.append(URLQueryItem(name: "count", value: "10"))

        if let startTime = startTime {
            urlConstructor.queryItems?.append(URLQueryItem(name: "start_time", value: "\(startTime)"))
               }
        
        guard let url = urlConstructor.url else {
            return completion(.failure(.invalidUrl),
                              .failure(.invalidUrl))}

        session.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard
                error == nil,
                let responseData = data
            else { return completion(.failure(.requestFailed),
                                     .failure(.requestFailed)) }
            var posts: [News] = []
            var profiles: [User] = []
            var groups: [Community] = []
            var nextFrom: String = ""
            
//            do {
                DispatchQueue.global().async(group: self.dispatchGroup, qos: .userInitiated) {
                let next = try? JSONDecoder().decode(Newsfeed.self, from: responseData).nextFrom
                    nextFrom = next ?? ""
                }
               
            DispatchQueue.global().async(group: self.dispatchGroup, qos: .userInitiated) {
                let postJSON = try? JSONDecoder().decode(Newsfeed.self, from: responseData).items
                posts = postJSON ?? []
            }
            DispatchQueue.global().async(group: self.dispatchGroup, qos: .userInitiated) {
                let userJSON = try? JSONDecoder().decode(Newsfeed.self, from: responseData).profiles
             profiles = userJSON ?? []
            }
            DispatchQueue.global().async(group: self.dispatchGroup, qos: .userInitiated) {
                let groupsJSON = try? JSONDecoder().decode(Newsfeed.self, from: responseData).groups
             groups = groupsJSON ?? []
            }

                self.dispatchGroup.notify(queue: DispatchQueue.global()) {
                    let newsWithSources = posts.compactMap { posts -> News? in
                        if posts.sourceId > 0 {
                            let news = posts
                            guard let newsID = profiles.first(where: { $0.id == posts.sourceId})
                            else { return nil }
                            news.urlProtocol = newsID
                            return news
                        } else {
                            let news = posts
                            guard let newsID = groups.first(where: { -$0.id == posts.sourceId})
                            else { return nil }
                            news.urlProtocol = newsID
                            return news
                        }
                    }
                    DispatchQueue.main.async {
                        completion(.success(newsWithSources), .success(nextFrom))
                    }
                }
//            } catch {
//                print(completion(.failure(.decoderError), .failure(.decoderError)))
            
        }.resume()
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
