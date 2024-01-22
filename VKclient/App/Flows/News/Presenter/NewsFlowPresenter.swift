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
        }
    }
}

protocol NewsFlowViewInput {
    func updateTableView()
}

protocol NewsFlowViewOutput {
    var newsPost: [News] { get set}
    var nextNews: String { get set}
    var isLoading: Bool { get set }
    func loadNews()
    func loadNextData(startFrom: String, completion: @escaping ([News], String) -> Void)
}

final class NewsFlowPresenter {
    @Injected (\.newsService) var newsService
    internal var newsPost: [News] = []
    internal var nextNews = ""
    internal var isLoading = false
    
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
}

extension NewsFlowPresenter: NewsFlowViewOutput {
    func loadNews() {
        self.loadData()
    }
}
