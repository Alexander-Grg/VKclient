//
//  NewsTableViewController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 16.09.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
//TODO: Fix the videos, fix the likes when adding additional news. Add commends section to the app.

final class NewsTableViewController: UIViewController {
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .singleLine

        return table
    }()
    private let textCellFont = UIFont(name: "Avenir-Light", size: 16.0) ?? UIFont.systemFont(ofSize: 16)
    private let defaultCellHeight: CGFloat = 130
    private var presenter: NewsFlowViewOutput
    private var isPressedState: [IndexPath: Bool] = [:]
    
    init(presenter: NewsFlowViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.loadNews()
        self.setupTableView()
        tableView.prefetchDataSource = self
        tableView.dataSource = self
        tableView.delegate = self
        self.view.isUserInteractionEnabled = true
        configRefreshControl()
        
        self.tableView.register(NewsHeaderSection.self, forCellReuseIdentifier: NewsHeaderSection.identifier)
        self.tableView.register(NewsTableViewCellPost.self, forCellReuseIdentifier: NewsTableViewCellPost.identifier)
        self.tableView.register(NewsTableViewCellPhoto.self, forCellReuseIdentifier: NewsTableViewCellPhoto.identifier)
        self.tableView.register(NewsFooterSection.self, forCellReuseIdentifier: NewsFooterSection.identifier)
        self.tableView.register(NewsTableViewCellVideo.self, forCellReuseIdentifier: NewsTableViewCellVideo.identifier)
        
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
        self.presenter.loadNews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Simulate refresh delay
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension NewsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.newsPost[section].rowsCounter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = self.presenter.newsPost[indexPath.section]

        switch news.rowsCounter[indexPath.row] {
        case .header:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsHeaderSection.identifier) as? NewsHeaderSection else { return NewsHeaderSection() }
            cell.configureCell(news)
            
            return cell
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCellPost.identifier) as? NewsTableViewCellPost,
                  let text = news.text
            else { return NewsTableViewCellPost() }
            
            let textHeight = text.heightWithConstrainedWidth(width: tableView.frame.width, font: textCellFont)
            
            cell.configureCell(news, isTapped: textHeight > defaultCellHeight, isButtonPressed: self.isPressedState[indexPath] ?? false)
            cell.delegate = self
            
            return cell
        case .photo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCellPhoto.identifier) as? NewsTableViewCellPhoto else { return NewsTableViewCellPhoto() }
            
            
            cell.configure(images: news.attachmentPhotos, index: 0)
            cell.delegate = self
            
            return cell
        case .footer:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFooterSection.identifier) as? NewsFooterSection
            else { return NewsFooterSection() }
            cell.configureCell(news, currentLikeState: news.likes)
            cell.likesButton.delegate = self
            cell.commentDelegate = self
            return cell
            
        case .video:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCellVideo.identifier) as? NewsTableViewCellVideo else { return NewsTableViewCellVideo() }
            self.presenter.getVideos(ownIDvidIDkey: news.videoAccessString ?? "") { video in
                cell.configure(video)
            }

            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.presenter.newsPost.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.presenter.newsPost[indexPath.section].rowsCounter[indexPath.row] {
        case .header:
            return 75
        case .footer:
            return 60
        case .photo:
            let tableWidth = tableView.bounds.width
            let ratio = self.presenter.newsPost[indexPath.section].aspectRatio
            let newsCGfloatRatio = CGFloat(ratio)
            return newsCGfloatRatio * tableWidth
        case .text:
            let isPressed = isPressedState[indexPath] ?? false
            return isPressed ? UITableView.automaticDimension : defaultCellHeight
        case .video:
            let tableWidth = tableView.bounds.width
            let ratio = self.presenter.newsPost[indexPath.section].videoAspectRatio
            return ratio * tableWidth
        }
    }
}

extension NewsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewsTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSections = indexPaths.map({ $0.section }).max() else { return }
        
        if maxSections > self.presenter.newsPost.count - 3, !self.presenter.isLoading {
            self.presenter.isLoading = true
            
            self.presenter.loadNextData(startFrom: self.presenter.nextNews) { news, nextFrom in
                DispatchQueue.main.async {
                    let startingIndex = self.presenter.newsPost.count
                    let indexSet = IndexSet(integersIn: startingIndex ..< (startingIndex + news.count))
                    self.presenter.newsPost.append(contentsOf: news)
                    self.presenter.nextNews = nextFrom
                    
                    for section in startingIndex..<self.presenter.newsPost.count {
                        for row in 0..<self.presenter.newsPost[section].rowsCounter.count {
                            let indexPath = IndexPath(row: row, section: section)
                            self.isPressedState[indexPath] = false // Default state
                        }
                    }
                    
                    tableView.performBatchUpdates {
                        tableView.insertSections(indexSet, with: .automatic)
                    }
                    self.presenter.isLoading = false
                }
            }
        }
    }
}

extension NewsTableViewController: NewsDelegate {
    func buttonTapped(cell: NewsTableViewCellPost) {
        if let indexPath = tableView.indexPath(for: cell) {
            isPressedState[indexPath] = !(isPressedState[indexPath] ?? false)
            tableView.performBatchUpdates {
                self.tableView.reloadData()
            }
        }
    }
}

extension NewsTableViewController: NewsFlowViewInput {
    func updateTableView() {
        var newState: [IndexPath: Bool] = [:]
        
        for section in 0..<self.presenter.newsPost.count {
            for row in 0..<self.presenter.newsPost[section].rowsCounter.count {
                let indexPath = IndexPath(row: row, section: section)
                newState[indexPath] = self.isPressedState[indexPath] ?? false
            }
        }
        
        self.isPressedState = newState
        self.tableView.reloadData()
    }
}

extension NewsTableViewController: NewsTableViewCellPhotoDelegate {
    func didTapPhotoCell(images: [String], index: Int) {
        let vc = ExtendedPhotoViewController(arrayOfPhotosFromDB: images, indexOfSelectedPhoto: index)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewsTableViewController: LikeControlDelegate {
    func didLike(in cell: NewsFooterSection?) {
        guard let cell = cell,
              let indexPath = tableView.indexPath(for: cell)
        else { return }

        let news = presenter.newsPost[indexPath.section]

        if news.likes?.canLike == 1 {
            presenter.setLike(itemID: String(news.postID ?? 0), ownerID: String(news.sourceId))
        } else if news.likes?.canLike == 0 {
            presenter.removeLike(itemID: String(news.postID ?? 0),ownerID: String(news.sourceId))
        }
        self.presenter.loadNews()
        cell.configureCell(news, currentLikeState: news.likes)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension NewsTableViewController: CommentControlDelegate {
    func didTapComment(in cell: NewsFooterSection?) {
           guard let cell = cell,
                 let indexPath = tableView.indexPath(for: cell)
           else {
               print("Failed to get cell or indexPath")
               return
           }
        let news = presenter.newsPost[indexPath.section]

        let commentsVC = CommentsFlowViewBuilder.build(ownerID: news.sourceId, postID: news.postID ?? 0)
           present(commentsVC, animated: true) {
           }
       }
}
