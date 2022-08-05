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

protocol AbstractUrlConstructor {
    
    var session: URLSession { get }
    var constructorScheme: String { get set }
    var constructorHost: String { get set }
    var constructorPath: String { get set }
    var queryItems: [URLQueryItem] { get set }
    var constructor: URLComponents { get set }
    
    func dataTaskRequest(completion: @escaping (Result<Data, RequestErrors>) -> Void)
}

class VKConstructor: AbstractUrlConstructor {
    
    var session: URLSession = URLSession.shared
    var constructorScheme: String = "https"
    var constructorHost: String = "api.vk.com"
    var constructorPath: String
    var queryItems: [URLQueryItem]
    var constructor: URLComponents = {
        var constructor = URLComponents()
        constructor.queryItems = [
            URLQueryItem(name: "v", value: "5.92"),
            URLQueryItem(name: "access_token", value: Session.instance.token)]
        
        return constructor
    }()
    
    init(constructorPath: String, queryItems: [URLQueryItem]) {
        
        self.constructorPath = "/method/\(constructorPath)"
        self.queryItems = queryItems
        self.constructor.path = self.constructorPath
        self.constructor.host = constructorHost
        self.constructor.scheme = constructorScheme
        self.constructor.queryItems? += queryItems
    }
    
    func dataTaskRequest(completion: @escaping (Result<Data, RequestErrors>) -> Void)  {
        guard let url = constructor.url  else { return completion(.failure(.invalidUrl))}
        
        session.dataTask(with: url) { data, response, error in
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
