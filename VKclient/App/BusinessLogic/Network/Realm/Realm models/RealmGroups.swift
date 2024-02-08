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
    @Persisted var photo200: String = ""
    @Persisted var isDeleted: String = ""
    @Persisted var groupStatus: String
    @Persisted var isMember: String
}

extension GroupsRealm {
    convenience init(groups: GroupsObjects) {
        self.init()

        self.photo = groups.photo
        self.name = groups.name
        self.id = groups.id
        self.photo = groups.photo
        self.photo200 = groups.photo200
        self.isDeleted = groups.isDeactivated ?? ""
        self.groupStatus = groups.groupStatusString
        self.isMember = groups.isMemberString
    }
}
