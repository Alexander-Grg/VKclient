//
//  DependencyInjection.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-01-22.
//

import Foundation

public protocol InjectionKey {

    /// The associated type representing the type of the dependency injection key's value.
    associatedtype Value

    /// The default value for the dependency injection key.
    static var currentValue: Self.Value { get set }
}

struct InjectedValues {

    /// This is only used as an accessor to the computed properties within extensions of `InjectedValues`.
    private static var current = InjectedValues()

    /// A static subscript for updating the `currentValue` of `InjectionKey` instances.
    static subscript<K>(key: K.Type) -> K.Value where K : InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }

    /// A static subscript accessor for updating and references dependencies directly.
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
    var userService: UserServiceProtocol {
        get { Self[UserServiceKey.self] }
        set { Self[UserServiceKey.self] = newValue }
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
}
