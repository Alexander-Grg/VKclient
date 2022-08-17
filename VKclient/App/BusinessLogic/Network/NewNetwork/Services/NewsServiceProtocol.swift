//
//  NewsServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/17/22.
//

import Foundation
import Combine

protocol NewsServiceProtocol {
    func getNews(startFrom: String) -> AnyPublisher<Data, Error>
}

final class NewsService: NewsServiceProtocol {
    private let apiProvider = APIProvider<NewsfeedEndpoint>()
    
    func getNews(startFrom: String = "") -> AnyPublisher<Data, Error> {
        apiProvider.getData(from: .getNews(startFrom: startFrom))
            .eraseToAnyPublisher()
    }
}
