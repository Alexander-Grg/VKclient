//
//  NewsFlowPresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//

import UIKit
import Combine
import RealmSwift

enum NewsTypes {
    case photo
    case text
    case header
    case footer
    case video

    func rowsToDisplay() -> UITableViewCell.Type {
        switch self {
        case .photo:
            return NewsTableViewCellPhoto.self
        case .text:
            return NewsTableViewCellPost.self
        case .footer:
            return NewsFooterSection.self
        case .header:
            return NewsHeaderSection.self
        case .video:
            return NewsTableViewCellVideo.self
        }
    }
    
    var cellIdentifiersForRows: String {
        switch self {
        case .photo:
            return NewsTableViewCellPhoto.identifier
        case .text:
            return  NewsTableViewCellPost.identifier
        case .footer:
            return NewsFooterSection.identifier
        case .header:
            return NewsHeaderSection.identifier
        case .video:
            return NewsTableViewCellVideo.identifier
        }
    }
}

protocol NewsFlowViewInput {
    func updateTableView()
}

protocol NewsFlowViewOutput {
    var newsPost: [News] { get set}
    var newsVideos: [VideoItem] { get set }
    var nextNews: String { get set}
    var isLoading: Bool { get set }
    func loadNews()
    func loadNextData(startFrom: String, completion: @escaping ([News], String) -> Void)
    func setLike(itemID: String, ownerID: String)
    func removeLike(itemID: String, ownerID: String)
    func getVideos(ownIDvidIDkey: String, completion: @escaping (VideoItem?) -> Void)
}

final class NewsFlowPresenter {
    @Injected(\.newsService) var newsService
    @Injected(\.likesService) var likesService
    @Injected(\.videosService) var videosService
    private var cancellable = Set<AnyCancellable>()
    internal var newsPost: [News] = []
    internal var newsVideos: [VideoItem] = []
    internal var nextNews = ""
    internal var isLoading = false
    internal var likesCount = 0

    weak var viewInput: (UIViewController & NewsFlowViewInput)?
    
    private func loadData() {
        newsService.getNews(startFrom: "", startTime: nil) { [weak self] news, nextFrom in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.newsPost = news
                self.nextNews = nextFrom
                self.viewInput?.updateTableView()
            }
        }
    }
    
    func loadNextData(startFrom: String, completion: @escaping ([News], String) -> Void) {
        newsService.getNews(startFrom: startFrom, startTime: nil) { newNews, nextFrom in
            DispatchQueue.main.async {
                completion(newNews, nextFrom)
            }
        }
    }

    func setLike(itemID: String, ownerID: String) {
        likesService.setLike(type: "post", itemID: itemID, ownerID: ownerID)
            .decode(type: Likes.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("The like method is finished")
                case .failure(let error):
                    print("The error appeared during the set like method \(error)")
                }}, receiveValue: {[weak self] value in
                    guard let self = self else { return }
                    self.likesCount = value.count
                    print("The like is set")
                }).store(in: &cancellable)
    }

    func removeLike(itemID: String, ownerID: String) {
        likesService.removeLike(type: "post", itemID: itemID, ownerID: ownerID)
            .decode(type: Likes.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("The remove like method is finished")
                case .failure(let error):
                    print("The error appeared during the like removal method \(error)")
                }}, receiveValue: {[weak self] value in
                    guard let self = self else { return }
                    self.likesCount = value.count
                    print("The like is removed")
                }).store(in: &cancellable)
    }

    func isLiked(itemID: String, ownerID: String) -> Bool {
        var isThisItemLiked: Bool = false
        likesService.isLiked(type: "post", itemID: itemID, ownerID: ownerID)
            .decode(type: Likes.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("The isLike method is finished")
                case .failure(let error):
                    print("The error appeared during the isLike method \(error)")
                }}, receiveValue: {[weak self] value in
                    guard let self = self else { return }
                    isThisItemLiked = value.canLike == 1 ? true : false
                }).store(in: &cancellable)
        
        return isThisItemLiked
    }

    func getVideos(ownIDvidIDkey: String, completion: @escaping (VideoItem?) -> Void) {
        videosService.requestVideos(ownIDvidIDkey: ownIDvidIDkey)
            .decode(type: VideoApiResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    print("Get videos method is finished")
                case .failure(let error):
                    print("The error appeared during the get videos method \(error)")
                    completion(nil)
                }
            }, receiveValue: { value in
                completion(value.response.items.first)
            })
            .store(in: &cancellable)
    }
}

extension NewsFlowPresenter: NewsFlowViewOutput {
    func loadNews() {
        self.loadData()
    }
}
