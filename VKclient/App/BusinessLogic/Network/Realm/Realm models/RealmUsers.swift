//
//  RealmUsers.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 17.10.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import RealmSwift

class UserRealm: Object {

    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var avatar: String = ""
    @Persisted var birthday: String = ""
    @Persisted var sex: String = ""
    @Persisted var location: String = ""
}

extension UserRealm {
    convenience init(user: FriendObject) {
        self.init()
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.id = user.id
        self.avatar = user.avatar
        self.birthday = user.birthdayMapped ?? ""
        self.sex = user.sexMapped
        self.location = user.city?.title ?? ""
    }
}
