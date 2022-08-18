//
//  NewsServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/17/22.
//

import Foundation
import Combine

protocol NewsServiceProtocol {
    func getNews(startFrom: String, startTime: Double?, _ completion: @escaping ([News], String)
                 -> Void)
}

final class NewsService: NewsServiceProtocol {
    
    var cancellable = Set<AnyCancellable>()
    private let apiProvider = APIProvider<NewsfeedEndpoint>()
    
    func getNews(startFrom: String = "", startTime: Double? = nil, _ completion: @escaping ([News], String)
                 -> Void){
        apiProvider.getData(from: .getNews(startFrom: startFrom))
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { value in
                let news = value.response.items
                let profiles = value.response.profiles
                let groups = value.response.groups
                let nextFrom = value.response.nextFrom
                
                let newsWithSources = news.compactMap { posts -> News? in
                    if posts.sourceId > 0 {
                        var news = posts
                        guard let newsID = profiles.first(where: { $0.id == posts.sourceId})
                        else { return nil }
                        news.urlProtocol = newsID
                        return news
                    } else {
                        var news = posts
                        guard let newsID = groups.first(where: { -$0.id == posts.sourceId})
                        else { return nil }
                        news.urlProtocol = newsID
                        return news
                    }
                }
                completion(newsWithSources, nextFrom)
            }
            )
            .store(in: &cancellable)
    }
}
