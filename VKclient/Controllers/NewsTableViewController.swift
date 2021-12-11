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
    public var newsPost: [PostNews]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var dictOfUsers: [String: [UserRealm]] = [:]
    var IDs = [Int]()
    var groupsForHeader: [GroupNews] = []
    var usersForHeader: [UserNews] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NewsHeaderSection", bundle: nil), forCellReuseIdentifier: "NewsHeaderSection")
        tableView.register(UINib(nibName: "NewsFooterSection", bundle: nil), forCellReuseIdentifier: "NewsFooter")
        loadNews()
    }
    
    func loadNews() {
        networkService.loadNewsFeed { [weak self] newsPost in
            guard let self = self else { return }
            self.newsPost = newsPost
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
            cell.configure(news)
            return cell
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPostCell") as? NewsTableViewCellPost else { return NewsTableViewCellPost() }
            cell.configure(news)
            return cell
        case .photo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoCell") as? NewsTableViewCellPhoto else { return NewsTableViewCellPhoto() }
            cell.configure(news)
            return cell
        case .footer:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFooter") as? NewsFooterSection
            else { return NewsFooterSection() }
            cell.configure(news)
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


