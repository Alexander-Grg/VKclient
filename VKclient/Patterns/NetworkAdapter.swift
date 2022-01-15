//
//  NetworkAdapter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 15.01.2022.
//

import Foundation

// MARK: Load photos method
//func loadPhotos(token: String, ownerID: String)
////                        completion: @escaping ([PhotosObject]) -> Void)
//{
//    let configuration = URLSessionConfiguration.default
//    let session =  URLSession(configuration: configuration)
//
//    var urlConstructor = URLComponents()
//    urlConstructor.scheme = "https"
//    urlConstructor.host = "api.vk.com"
//    urlConstructor.path = "/method/photos.get"
//    urlConstructor.queryItems = [
//        URLQueryItem(name: "access_token", value: token),
//        URLQueryItem(name: "rev", value: "1"),
//        URLQueryItem(name: "owner_id", value: ownerID),
//        URLQueryItem(name: "album_id", value: "profile"),
//        URLQueryItem(name: "offset", value: "0"),
//        URLQueryItem(name: "photo_sizes", value: "0"),
//        URLQueryItem(name: "v", value: "5.92"),
//    ]
//
//    guard let url = urlConstructor.url else { return }
//    var request = URLRequest(url: url)
//    request.timeoutInterval = 50.0
//    request.setValue(
//        "",
//        forHTTPHeaderField: "Token")
//
//    session.dataTask(with: request) { responseData, urlResponse, error in
//        if let response = urlResponse as? HTTPURLResponse {
//            print(response.statusCode)
//        }
//        guard
//            error == nil,
//            let responseData = responseData
//        else { return }
//        do {
//            let user = try JSONDecoder().decode(PhotosResponse.self,
//                                                from: responseData).response.items
//
//            let groupRealm = user.map { RealmPhotos(photos: $0) }
//            DispatchQueue.main.async {
//                try? RealmService.save(items: groupRealm)
//            }
//
//
//        } catch {
//            print(error)
//        }
//    }
//    .resume()
//}

class NetworkPhotoAdapter {
    
}
