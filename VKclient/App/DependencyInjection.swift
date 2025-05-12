//
//  DependencyInjection.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-01-22.
//  Copyright © 2024–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation

public protocol InjectionKey {

    associatedtype Value

    static var currentValue: Self.Value { get set }
}

struct InjectedValues {

    private static var current = InjectedValues()

    static subscript<K>(key: K.Type) -> K.Value where K : InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }

    static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

@propertyWrapper
struct Injected<T> {
    private let keyPath: WritableKeyPath<InjectedValues, T>
    var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }

    init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}

extension InjectedValues {
    var userService: FriendsServiceProtocol {
        get { Self[FriendsServiceKey.self] }
        set { Self[FriendsServiceKey.self] = newValue }
    }

    var groupsService: GroupsServiceProtocol {
        get { Self[GroupsServiceKey.self] }
        set { Self[GroupsServiceKey.self] = newValue }
    }

    var photosService: PhotosServiceProtocol {
        get { Self[PhotosServiceKey.self] }
        set { Self[PhotosServiceKey.self] = newValue }
    }

    var groupsSearchService: GroupSearchProtocol {
        get { Self[GroupsSearchKey.self] }
        set { Self[GroupsSearchKey.self] = newValue }
    }

    var newsService: NewsServiceProtocol {
        get { Self[NewsServiceKey.self] }
        set { Self[NewsServiceKey.self] = newValue }
    }

    var groupActionsService: GroupsActionProtocol {
        get { Self[GroupsActionsKey.self] }
        set { Self[GroupsActionsKey.self] = newValue }
    }

    var realmService: RealmServiceProtocol {
        get { Self[RealmServiceKey.self] }
        set { Self[RealmServiceKey.self] = newValue }
    }

    var likesService: LikesServiceProtocol {
        get { Self[LikesServiceKey.self] }
        set { Self[LikesServiceKey.self] = newValue }
    }

    var videosService: VideosServiceProtocol {
        get { Self[VideosServiceKey.self] }
        set { Self[VideosServiceKey.self] = newValue }
    }

    var commentsService: CommentsServiceProtocol {
        get { Self[CommentsServiceKey.self] }
        set { Self[CommentsServiceKey.self] = newValue }
    }

    var usersService: UsersServiceProtocol {
        get { Self[UsersServiceKey.self] }
        set { Self[UsersServiceKey.self] = newValue }
    }
}
