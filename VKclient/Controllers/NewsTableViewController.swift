//
//  NewsTableViewController.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 16.09.2021.
//

import UIKit
import SDWebImage
import SwiftUI

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
            return "NewsPhotoCell"
        case .text:
            return  "NewsPostCell"
        case .footer:
            return "NewsFooter"
        case .header:
            return "NewsHeaderSection"
        }
    }
}

class NewsTableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let token = Session.instance.token
    let networkService = NetworkService()
    var newsPost: [News]?
    var IDs = [Int]()
    var groupsForHeader: [Community] = []
    var usersForHeader: [User] = []
    var nextFrom = ""
    var isLoading = false
    private let textCellFont = UIFont(name: "Avenir-Light", size: 16.0)!
    private let defaultCellHeight: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNews()
        tableView.prefetchDataSource = self
        configRefreshControl()
        
        self.tableView.register(NewsHeaderSection.self, forCellReuseIdentifier: NewsHeaderSection.reuseIdentifier)
        self.tableView.register(NewsTableViewCellPost.self, forCellReuseIdentifier: NewsTableViewCellPost.reusedIdentifier)
        self.tableView.register(NewsTableViewCellPhoto.self, forCellReuseIdentifier: NewsTableViewCellPhoto.reuseIdentifier)
        self.tableView.register(NewsFooterSection.self, forCellReuseIdentifier: NewsFooterSection.reuseIdentifier)
        
    }
    
    private func loadNews() {
        networkService.loadNewsFeed { [weak self] newsPost, nextFrom  in
            guard let self = self else { return }
            self.newsPost = newsPost
            //            DispatchQueue.main.async {
            self.tableView.reloadData()
            //            }
        }
    }
    
    private func configRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self,
                          action: #selector(didRefresh),
                          for: .valueChanged)
        tableView.refreshControl = refresh
    }
    
    @objc private func didRefresh() {
        tableView.refreshControl?.beginRefreshing()
        _ = Date().timeIntervalSince1970 + 1
        networkService.loadNewsFeed { [weak self] news, nextFrom in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension NewsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsPost?[section].rowsCounter.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let news = newsPost?[indexPath.section] else { return NewsTableViewCellPost() }
        
        switch news.rowsCounter[indexPath.row] {
        case .header:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsHeaderSection") as? NewsHeaderSection else { return NewsHeaderSection() }
            cell.configureCell(news)
            
            return cell
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPostCell") as? NewsTableViewCellPost else { return NewsTableViewCellPost() }
            
            let textHeight = news.text.heightWithConstrainedWidth(width: tableView.frame.width, font: textCellFont)
            cell.configureCell(news, isTapped: textHeight > defaultCellHeight)
            cell.delegate = self
            
            return cell
        case .photo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoCell") as? NewsTableViewCellPhoto else { return NewsTableViewCellPhoto() }
            cell.configure(news)
            
            return cell
        case .footer:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFooterSection.reuseIdentifier) as? NewsFooterSection
            else { return NewsFooterSection() }
            cell.configureCell(news)
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        newsPost?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch newsPost?[indexPath.section].rowsCounter[indexPath.row] {
        case .header:
            return 75
        case .footer:
            return 40
        case .photo:
            let tableWidth = tableView.bounds.width
            let newsAttachments = newsPost?[indexPath.section].attachments
            let newsRatio = newsAttachments?[indexPath.section].photo?.aspectRatio ?? 0
            let newsCGfloatRatio = CGFloat(newsRatio)
            return newsCGfloatRatio * tableWidth
        case .text:
            let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCellPost
            return (cell?.isPressed ?? false) ? UITableView.automaticDimension : defaultCellHeight
        default:
            return UITableView.automaticDimension
        }
    }
}

extension NewsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true)}
    }
}

extension NewsTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        guard let maxSections = indexPaths.map({ $0.section }).max() else { return }
        guard let newsItems = self.newsPost else { return }
        
        
        if maxSections > newsItems.count - 3, !isLoading {
            isLoading = true
            
            networkService.loadNewsFeed(startFrom: nextFrom) { [weak self] (news, nextFrom) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let indexSet = IndexSet(integersIn: (self.newsPost?.count ?? 0) ..< ((self.newsPost?.count ?? 0) + news.count))
                    
                    self.newsPost?.append(contentsOf: news)
                    print(news)
                    self.nextFrom = nextFrom
                    
                    tableView.beginUpdates()
                    self.tableView.insertSections(indexSet, with: .automatic)
                    tableView.endUpdates()
                    
                    self.isLoading = false
                }
            }
        }
    }
}

extension NewsTableViewController: NewsDelegate {
    func buttonTapped(cell: NewsTableViewCellPost) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
}
