//
//  RealmService.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 17.10.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import RealmSwift

struct RealmServiceKey: InjectionKey {
   static var currentValue: RealmServiceProtocol = RealmService()
}

protocol RealmServiceProtocol {
    func save<T: Object>(
        items: [T],
        configuration: Realm.Configuration,
        update: Realm.UpdatePolicy
    ) throws

    func load<T: Object>(typeOf: T.Type) throws -> Results<T>

    func delete<T: Object>(object: Results<T>) throws

    func get<T: Object>(
        type: T.Type,
        configuration: Realm.Configuration
    ) throws -> Results<T>
}

final class RealmService: RealmServiceProtocol {
    private let defaultConfiguration: Realm.Configuration

    init(configuration: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)) {
        self.defaultConfiguration = configuration
    }

    func save<T: Object>(
        items: [T],
        configuration: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true),
        update: Realm.UpdatePolicy = .modified
    ) throws {
        let realm = try Realm(configuration: configuration)
        print(configuration.fileURL ?? "")
        try realm.write {
            realm.add(items, update: update)
        }
    }

    func load<T: Object>(typeOf: T.Type) throws -> Results<T> {
        let realm = try Realm(configuration: self.defaultConfiguration)
        return realm.objects(typeOf)
    }

    func delete<T: Object>(object: Results<T>) throws {
        let realm = try Realm(configuration: self.defaultConfiguration)
        try realm.write {
            realm.delete(object)
        }
    }

    func get<T: Object>(
        type: T.Type,
        configuration: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    ) throws -> Results<T> {
        let realm = try Realm(configuration: configuration)
        print(configuration.fileURL ?? "")
        return realm.objects(type)
    }
}
