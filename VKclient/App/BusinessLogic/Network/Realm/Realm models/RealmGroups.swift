//
//  Realm.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 17.10.2021.
//

import RealmSwift

class GroupsRealm: Object {
    @Persisted var name: String = ""
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var photo: String = ""
}

extension GroupsRealm {
    convenience init(groups: GroupsObjects) {
        self.init()

        self.photo = groups.photo
        self.name = groups.name
        self.id = groups.id
        self.photo = groups.photo
    }
}
