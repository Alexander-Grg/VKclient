//
//  EndpointProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/15/22.
//

import Foundation

protocol EndpointProtocol {
    var baseURL: String { get }
    var absoluteURL: String { get }
    var parameters: [String : String] { get }
}

extension EndpointProtocol {
    var baseURL: String {
        return "https://api.vk.com"
    }

}
