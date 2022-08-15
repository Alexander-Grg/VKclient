//
//  Container.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/15/22.
//

import Foundation

final class Container {
    static let jsonDecoder: JSONDecoder = JSONDecoder()

    static let APIkey: String = Session.instance.token
}
