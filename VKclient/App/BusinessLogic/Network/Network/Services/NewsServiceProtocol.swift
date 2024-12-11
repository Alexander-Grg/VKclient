//
//  NewsServiceProtocol.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/17/22.
//

import Foundation
import Combine

struct NewsServiceKey: InjectionKey {
   static var currentValue: NewsServiceProtocol = NewsService()
}

protocol NewsServiceProtocol: AnyObject {
    func getNews(startFrom: String, startTime: Double?, _ completion: @escaping ([News], String)
                 -> Void)
}

struct FallbackSource: NewsSource {
    var name = "Unknown Source"
    var urlString = ""
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
                

                let newsWithSources = news.map { post -> News in
                    var newPost = post
                    if post.sourceId > 0 {
                        // If no profile is found, assign fallback
                        newPost.urlProtocol = profiles.first(where: { $0.id == post.sourceId }) ?? FallbackSource()
                    } else {
                        // If no group is found, assign fallback
                        newPost.urlProtocol = groups.first(where: { -$0.id == post.sourceId }) ?? FallbackSource()
                    }
                    return newPost
                }
                completion(newsWithSources, nextFrom)
            }
            )
            .store(in: &cancellable)
    }
}
