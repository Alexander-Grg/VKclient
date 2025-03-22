//
//  NewsServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/17/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation
import Combine

struct NewsServiceKey: InjectionKey {
    static var currentValue: NewsServiceProtocol = NewsService()
}

protocol NewsServiceProtocol: AnyObject {
    func getNews(startFrom: String, startTime: Double?, _ completion: @escaping ([News], String) -> Void)
}

struct FallbackSource: NewsSource {
    var name = "Unknown Source"
    var urlString = ""
}

final class NewsService: NewsServiceProtocol {

    var cancellable = Set<AnyCancellable>()
    private let apiProvider = APIProvider<NewsfeedEndpoint>()

    func getNews(startFrom: String = "", startTime: Double? = nil, _ completion: @escaping ([News], String) -> Void) {
        apiProvider.getData(from: .getNews(startFrom: startFrom))
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print("Error while fetching news: \(error)")
            }, receiveValue: { response in
                let news = response.response.items
                let profiles = response.response.profiles
                let groups = response.response.groups
                let nextFrom = response.response.nextFrom

                let mappedNews = news.map { post -> News in
                    var updatedPost = post
                    if post.sourceId > 0 {
                        updatedPost.urlProtocol = profiles.first(where: { $0.id == post.sourceId }) ?? FallbackSource()

                    } else {
                        updatedPost.urlProtocol = groups.first(where: { -$0.id == post.sourceId }) ?? FallbackSource()
                    }

                    return updatedPost
                }
                completion(mappedNews, nextFrom)
            })
            .store(in: &cancellable)
    }
}
