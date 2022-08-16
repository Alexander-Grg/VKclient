//
//  NetworkService.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 02.10.2021.
//

import Foundation

final class GetFriends: VKConstructor {
    func requestFriends(completion: @escaping (Result<[UserObject], RequestErrors>) -> Void) {
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

//final class GetPhotos: VKConstructor {
//    func request(
//        completion: @escaping (Result<[RealmPhotos], RequestErrors>) -> Void) {
//        dataTaskRequest { result in
//            switch result {
//            case .success(let data):
//                do {
//                    let photos = try JSONDecoder().decode(PhotosResponse.self,
//                                                          from: data).response.items
//                    let photosRealm = photos.map { RealmPhotos(photos: $0)
//                    }
//                    DispatchQueue.main.async {
//                        completion(.success(photosRealm))
//                    }
//                } catch {
//                    print(completion(.failure(.decoderError)))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}

final class GetGroups: VKConstructor {
    func request(
        completion: @escaping (Result<[GroupsObjects], RequestErrors>) -> Void) {
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

final class GetGroupSearch: VKConstructor {
    func request(
        completion: @escaping ([GroupsObjects]) -> Void) {
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

final class GetNews: VKConstructor {

    let dispatchGroup = DispatchGroup()

    func request(startFrom: String = "", startTime: Double? = nil, _ completion: @escaping ([News], String)
                 -> Void) {
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
