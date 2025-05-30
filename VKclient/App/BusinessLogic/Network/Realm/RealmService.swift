//
//  RealmService.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 17.10.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import RealmSwift
import Foundation

struct RealmServiceKey: InjectionKey {
    static var currentValue: RealmServiceProtocol = RealmService()
}

protocol RealmServiceProtocol {
    func save<T: Object>(
        items: [T],
        update: Realm.UpdatePolicy
    ) throws

    func load<T: Object>(typeOf: T.Type) throws -> Results<T>

    func delete<T: Object>(object: Results<T>) throws

    func get<T: Object>(type: T.Type) throws -> Results<T>

    func deleteAll() throws
}

// MARK: - Implementation
final class RealmService: RealmServiceProtocol {
    private let defaultConfiguration: Realm.Configuration

    init() {
        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("default.realm")

        var config = Realm.Configuration()
        config.fileURL = fileURL
        config.deleteRealmIfMigrationNeeded = true

        self.defaultConfiguration = config
    }

    func save<T: Object>(
        items: [T],
        update: Realm.UpdatePolicy = .modified
    ) throws {
        let realm = try Realm(configuration: defaultConfiguration)
        print("Realm save path:", defaultConfiguration.fileURL ?? "")
        try realm.write {
            realm.add(items, update: update)
        }
    }

    func load<T: Object>(typeOf: T.Type) throws -> Results<T> {
        let realm = try Realm(configuration: defaultConfiguration)
        return realm.objects(typeOf)
    }

    func delete<T: Object>(object: Results<T>) throws {
        let realm = try Realm(configuration: defaultConfiguration)
        try realm.write {
            realm.delete(object)
        }
    }

    func deleteAll() throws {
        let realm = try Realm(configuration: defaultConfiguration)
        try realm.write {
            realm.deleteAll()
        }
        print("All Realm data deleted.")
    }

    func get<T: Object>(type: T.Type) throws -> Results<T> {
        let realm = try Realm(configuration: defaultConfiguration)
        print("Realm get path:", defaultConfiguration.fileURL ?? "")
        return realm.objects(type)
    }
}
