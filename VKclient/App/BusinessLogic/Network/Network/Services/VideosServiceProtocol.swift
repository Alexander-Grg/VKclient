//
//  VideosServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 22/3/25.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//
import Combine
import Foundation

struct VideosServiceKey: InjectionKey {
   static var currentValue: VideosServiceProtocol = VideosService()
}

protocol VideosServiceProtocol: AnyObject {
    func requestVideos(ownIDvidIDkey: String) -> AnyPublisher<Data, Error>
}

final class VideosService: VideosServiceProtocol {

    private let apiProvider = APIProvider<VideosEndpoint>()

    func requestVideos(ownIDvidIDkey: String) -> AnyPublisher<Data, Error> {
        return apiProvider.getData(from: .getVideo(ownIDvidIDKey: ownIDvidIDkey))
            .eraseToAnyPublisher()
    }
}
