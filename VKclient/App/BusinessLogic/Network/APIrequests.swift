//
//  APIrequests.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 02.10.2021.
//

import Foundation

final class GetFriends: NetworkService {
    func request(completion: @escaping (Result<[UserObject], RequestErrors>) -> Void) {
        constructor.path += "friends.get"
        constructor.queryItems?.append(contentsOf: [
            URLQueryItem(
                name: "order",
                value: "random"),
            URLQueryItem(
                name: "fields",
                value: "nickname, photo_100")
        ])
        dataTaskRequest { result in
            switch result {
            case .success(let data):
                do {
                    let user = try JSONDecoder().decode(UserResponse.self,
                                                        from: data).response.items
                    let groupRealm = user.map { UserRealm(user: $0)
                    }
                    try RealmService.save(items: groupRealm)
                    DispatchQueue.main.async {
                        completion(.success(user))
                    }
                } catch {
                    print(completion(.failure(.decoderError)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

final class GetPhotos: NetworkService {
    func request(_ friendID: Int,
                 completion: @escaping (Result<[RealmPhotos], RequestErrors>) -> Void) {
        constructor.path += "photos.get"
        constructor.queryItems?.append(contentsOf: [
            URLQueryItem(
                name: "rev",
                value: "1"),
            URLQueryItem(
                name: "album_id",
                value: "profile"),
            URLQueryItem(
                name: "offset",
                value: "0"),
            URLQueryItem(
                name: "photo_sizes",
                value: "0"),
            URLQueryItem(
                name: "owner_id",
                value: String(friendID))
        ])
        dataTaskRequest { result in
            switch result {
            case .success(let data):
                do {
                    let photos = try JSONDecoder().decode(PhotosResponse.self,
                                                          from: data).response.items
                    let photosRealm = photos.map { RealmPhotos(photos: $0)
                    }
                    DispatchQueue.main.async {
                        completion(.success(photosRealm))
                    }
                } catch {
                    print(completion(.failure(.decoderError)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

final class GetGroups: NetworkService {
    func request(
        completion: @escaping (Result<[GroupsObjects], RequestErrors>) -> Void) {
            constructor.path += "groups.get"
            constructor.queryItems?.append(contentsOf: [
                URLQueryItem(
                    name: "extended",
                    value: "1"),
                URLQueryItem(
                    name: "fields",
                    value: "photo_100")
            ])
            dataTaskRequest { result in
                switch result {
                case .success(let data):
                    do {
                        let groups = try JSONDecoder().decode(GroupsResponse.self,
                                                              from: data).response.items
                        let groupsRealm = groups.map { GroupsRealm(groups: $0)
                        }
                        
                        DispatchQueue.main.async {
                            try? RealmService.save(items: groupsRealm)
                            completion(.success(groups))
                        }
                    } catch {
                        print(completion(.failure(.decoderError)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}

final class GetGroupSearch: NetworkService {
    func request(_ searchText: String,
                 completion: @escaping ([GroupsObjects]) -> Void) {
        constructor.path += "groups.search"
        constructor.queryItems?.append(contentsOf: [
            URLQueryItem(name: "sort", value: "6"),
            URLQueryItem(name: "type", value: "group"),
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "count", value: "20")
        ])
        dataTaskRequest { result in
            switch result {
            case .success(let data):
                do {
                    let groups = try JSONDecoder().decode(GroupsResponse.self,
                                                          from: data).response.items
                    DispatchQueue.main.async {
                        completion(groups)
                    }
                } catch {
                    print("Decoder error")
                }
            case .failure:
                completion([])
            }
        }
    }
}

final class GetNews: NetworkService {
    
    let dispatchGroup = DispatchGroup()
    
    func request(startFrom: String = "", startTime: Double? = nil, _ completion: @escaping ([News], String)
                 -> Void) {
        constructor.path += "newsfeed.get"
        constructor.queryItems?.append(contentsOf: [
            URLQueryItem(
                name: "filters",
                value: "post, photo"),
            URLQueryItem(
                name: "count",
                value: "20")
        ])
        constructor.queryItems?.append(
            URLQueryItem(
                name: "start_from",
                value: startFrom))
        
        if let startTime = startTime {
            constructor.queryItems?.append(URLQueryItem(name: "start_time", value: "\(startTime)"))
        }
        
        dataTaskRequest { result in
            switch result {
            case .success(let data):
                
                var posts: [News] = []
                var profiles: [User] = []
                var groups: [Community] = []
                var nextFrom = ""
                
                do {
                    let next: String = try JSONDecoder().decode(NewsResponse.self, from: data).response.nextFrom
                    nextFrom = next
                    
                    DispatchQueue.global().async(group: self.dispatchGroup, qos: .userInitiated) {
                        let postJSON = try? JSONDecoder().decode(NewsResponse.self, from: data).response.items
                        posts = postJSON ?? []
                    }
                    
                    DispatchQueue.global().async(group: self.dispatchGroup, qos: .userInitiated) {
                        let userJSON = try? JSONDecoder().decode(NewsResponse.self, from: data).response.profiles
                        profiles = userJSON ?? []
                    }
                    
                    DispatchQueue.global().async(group: self.dispatchGroup, qos: .userInitiated) {
                        let groupsJSON = try? JSONDecoder().decode(NewsResponse.self, from: data).response.groups
                        groups = groupsJSON ?? []
                    }
                    
                    self.dispatchGroup.notify(queue: DispatchQueue.global()) {
                        let newsWithSources = posts.compactMap { posts -> News? in
                            if posts.sourceId > 0 {
                                var news = posts
                                guard let newsID = profiles.first(where: { $0.id == posts.sourceId})
                                else { return nil }
                                news.urlProtocol = newsID
                                return news
                            } else {
                                var news = posts
                                guard let newsID = groups.first(where: { -$0.id == posts.sourceId})
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
                    completion([], "")
                    print(error)
                }
            case .failure:
                completion([], "")
            }
        }
    }
}
