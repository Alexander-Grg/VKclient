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
    @Persisted var groupStatus: Int
    @Persisted var isMember: Int

    var isMemberString: String {
        switch isMember {
        case 0:
            return "You're not a member"
        case 1:
            return "You're a group member"
        default:
           return ""
        }
    }
    var groupStatusString: String {
        switch groupStatus {
        case 0:
            return "The group is open"
        case 1:
            return "The group is closed"
        case 2:
            return "The group is private"
        default:
            return ""
        }
    }
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
        self.groupStatus = groups.isClosed
        self.isMember = groups.isMember
    }
}
