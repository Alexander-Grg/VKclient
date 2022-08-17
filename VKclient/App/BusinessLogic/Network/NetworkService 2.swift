//
//  NetworkConstructors.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 14.05.2022.
//

import Foundation
import UIKit

enum RequestErrors: String, Error {
    case invalidUrl
    case decoderError
    case requestFailed
    case unknownError
    case realmError
}



class NetworkService {
    var session: URLSession = URLSession.shared
    
    var constructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        constructor.path = "/method/"
        constructor.queryItems = [
            URLQueryItem(name: "v", value: "5.92"),
            URLQueryItem(name: "access_token", value: Session.instance.token)]

        return constructor
    }()

    func dataTaskRequest(completion: @escaping (Result<Data, RequestErrors>) -> Void) {
        guard let url = constructor.url  else
        { return completion(.failure(.invalidUrl))}

        session.dataTask(with: url) { data, response, _ in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.requestFailed))
            }
        }.resume()
    }
}
