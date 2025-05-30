//
//  Realm.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 17.10.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import RealmSwift

class GroupsRealm: Object {
    @Persisted var name: String = ""
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var photo: String = ""
    @Persisted var photo200: String = ""
    @Persisted var isDeleted: String = ""
    @Persisted var groupStatus: String
    @Persisted var isMemberString: String
    @Persisted var isMemberStatus: Int
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
        self.isMemberString = groups.isMemberString
        self.isMemberStatus = groups.isMember
    }
}
