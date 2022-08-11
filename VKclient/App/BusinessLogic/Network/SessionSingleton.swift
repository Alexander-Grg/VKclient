//
//  SessionSingleton.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 29.09.2021.
//

import Foundation

final class Session {

    static public let instance = Session()

    var token: String = ""
    var userID: Int = 0

    var friendID: Int = 0
    var photoIndex: Int = 0

    private init () {}

}
