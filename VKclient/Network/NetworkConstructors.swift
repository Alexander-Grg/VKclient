//
//  NetworkConstructors.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 14.05.2022.
//

import Foundation

class VKConstructor {
    
    let session = URLSession.shared
    let constructorScheme = "https"
    let constructorHost = "api.vk.com"
    let constructorPath: String
    var queryItems: [URLQueryItem]
    
    var constructor : URLComponents = {
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
}
