//
//  NewsTableViewController.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 16.09.2021.
//

import UIKit
import Combine

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

class NewsTableViewController: UIViewController {
    
    private var cancellable = Set<AnyCancellable>()
    private let newsService = NewsService()
    
    var newsPost: [News] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var IDs = [Int]()
    var groupsForHeader: [Community] = []
    var usersForHeader: [User] = []
    var nextFrom = ""
    var isLoading = false
    
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        
        return table
    }()
    
    private let textCellFont = UIFont(name: "Avenir-Light", size: 16.0)!
    private let defaultCellHeight: CGFloat = 200
    private var nextNews: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNews()
        self.setupTableView()
//        tableView.prefetchDataSource = self
        tableView.dataSource = self
        tableView.delegate = self
        
        configRefreshControl()
        
        self.tableView.register(NewsHeaderSection.self, forCellReuseIdentifier: NewsHeaderSection.identifier)
        self.tableView.register(NewsTableViewCellPost.self, forCellReuseIdentifier: NewsTableViewCellPost.identifier)
        self.tableView.register(NewsTableViewCellPhoto.self, forCellReuseIdentifier: NewsTableViewCellPhoto.identifier)
        self.tableView.register(NewsFooterSection.self, forCellReuseIdentifier: NewsFooterSection.identifier)
        
    }
    
    private func loadNews() {
        newsService.getNews(startFrom: nextFrom)
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                let news = value.response.items
                let profiles = value.response.profiles
                let groups = value.response.groups
                
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
                self.newsPost = newsWithSources
                self.nextFrom = value.response.nextFrom
            }
            )
            .store(in: &cancellable)

    }

    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
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

        self.loadNews()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension NewsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsPost[section].rowsCounter.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


            let news = newsPost[indexPath.section]
     

        switch news.rowsCounter[indexPath.row] {
        case .header:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsHeaderSection.identifier) as? NewsHeaderSection else { return NewsHeaderSection() }
            cell.configureCell(news)

            return cell
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCellPost.identifier) as? NewsTableViewCellPost else { return NewsTableViewCellPost() }

            let textHeight = news.text.heightWithConstrainedWidth(width: tableView.frame.width, font: textCellFont)
            cell.configureCell(news, isTapped: textHeight > defaultCellHeight)
            cell.delegate = self

            return cell
        case .photo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCellPhoto.identifier) as? NewsTableViewCellPhoto else { return NewsTableViewCellPhoto() }

            cell.configure(news)

            return cell
        case .footer:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFooterSection.identifier) as? NewsFooterSection
            else { return NewsFooterSection() }
            cell.configureCell(news)

            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        newsPost.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch newsPost[indexPath.section].rowsCounter[indexPath.row] {
        case .header:
            return 75
        case .footer:
            return 40
        case .photo:
            let tableWidth = tableView.bounds.width
           let ratio = newsPost[indexPath.section].aspectRatio
            let newsCGfloatRatio = CGFloat(ratio)
            return newsCGfloatRatio * tableWidth
        case .text:
            let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCellPost
            return (cell?.isPressed ?? false) ? UITableView.automaticDimension : defaultCellHeight
        }
    }
}

extension NewsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true)}
    }
}

//extension NewsTableViewController: UITableViewDataSourcePrefetching {
//
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//
//        guard let maxSections = indexPaths.map({ $0.section }).max() else { return }
//
//        if maxSections > newsPost.count - 3, !isLoading {
//            isLoading = true
//
//
//
////            newsRequest.request(startFrom: nextNews) {[weak self] (news, nextFrom) in
////                guard let self = self else { return }
//
//
//
//                DispatchQueue.main.async {
//                    let indexSet = IndexSet(integersIn: (self.newsPost?.count ?? 0) ..< ((self.newsPost?.count ?? 0) + news.count))
//
//                    self.newsPost?.append(contentsOf: news)
//                    print(news)
//
//                    self.nextNews = nextFrom
//
//                    tableView.beginUpdates()
//                    self.tableView.insertSections(indexSet, with: .automatic)
//                    tableView.endUpdates()
//                    self.isLoading = false
//                }
////            }
//        }
//    }
//}

extension NewsTableViewController: NewsDelegate {
    func buttonTapped(cell: NewsTableViewCellPost) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}
