//
//  RealmUsers.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 17.10.2021.
//

import RealmSwift

class UserRealm: Object {

    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var avatar: String = ""
}

extension UserRealm {
    convenience init(user: UserObject) {
        self.init()
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.id = user.id
        self.avatar = user.avatar
    }
}
