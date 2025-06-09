//
//  NewsTableViewController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 16.09.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

final class FeedTableViewController: UIViewController {
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .singleLine

        return table
    }()
    private let textCellFont = UIFont(name: "Avenir-Light", size: 16.0) ?? UIFont.systemFont(ofSize: 16)
    private let defaultCellHeight: CGFloat = 130
    private var presenter: FeedFlowOutput
    private var isPressedState: [IndexPath: Bool] = [:]
    private var pendingIndexPath: IndexPath?
    private var loadingIndicator: UIActivityIndicatorView?

    init(presenter: FeedFlowOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.loadFeed()
        self.setupTableView()
        tableView.prefetchDataSource = self
        tableView.dataSource = self
        tableView.delegate = self
        self.view.isUserInteractionEnabled = true
        configRefreshControl()
        showLoadingIndicator()

        self.tableView.register(FeedTableViewHeaderCell.self, forCellReuseIdentifier: FeedTableViewHeaderCell.identifier)
        self.tableView.register(FeedTableViewCellText.self, forCellReuseIdentifier: FeedTableViewCellText.identifier)
        self.tableView.register(FeedTableViewCellPhoto.self, forCellReuseIdentifier: FeedTableViewCellPhoto.identifier)
        self.tableView.register(FeedFooterSectionCell.self, forCellReuseIdentifier: FeedFooterSectionCell.identifier)
        self.tableView.register(FeedTableViewCellVideo.self, forCellReuseIdentifier: FeedTableViewCellVideo.identifier)
        
    }

    func restoreScroll(to indexPath: IndexPath) {
        pendingIndexPath = indexPath
    }

    private func showLoadingIndicator() {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = self.view.center
        indicator.startAnimating()
        self.view.addSubview(indicator)
        loadingIndicator = indicator
    }

    private func hideLoadingIndicator() {
        loadingIndicator?.stopAnimating()
        loadingIndicator?.removeFromSuperview()
        loadingIndicator = nil
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
        self.presenter.loadFeed()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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

extension FeedTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.feedPosts[section].rowsCounter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = self.presenter.feedPosts[indexPath.section]

        switch news.rowsCounter[indexPath.row] {
        case .header:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewHeaderCell.identifier) as? FeedTableViewHeaderCell else { return FeedTableViewHeaderCell() }
            cell.configureCell(news, user: presenter.user, type: presenter.type)

            return cell
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCellText.identifier) as? FeedTableViewCellText,
                  let text = news.text
            else { return FeedTableViewCellText() }
            
            let textHeight = text.heightWithConstrainedWidth(width: tableView.frame.width, font: textCellFont)
            
            cell.configureCell(news, isTapped: textHeight > defaultCellHeight, isButtonPressed: self.isPressedState[indexPath] ?? false)
            cell.delegate = self
            
            return cell
        case .photo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCellPhoto.identifier) as? FeedTableViewCellPhoto else { return FeedTableViewCellPhoto() }
            
            
            cell.configure(images: news.attachmentPhotos, index: 0)
            cell.delegate = self
            
            return cell
        case .footer:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedFooterSectionCell.identifier) as? FeedFooterSectionCell
            else { return FeedFooterSectionCell() }
            cell.configureCell(news, currentLikeState: news.likes)
            cell.likesButton.postDelegate = self
            cell.commentDelegate = self
            return cell
            
        case .video:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCellVideo.identifier) as? FeedTableViewCellVideo else { return FeedTableViewCellVideo() }
            self.presenter.getVideos(ownIDvidIDkey: news.videoAccessString ?? "") { video in
                cell.configure(video)
            }

            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.presenter.feedPosts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.presenter.feedPosts[indexPath.section].rowsCounter[indexPath.row] {
        case .header:
            return 75
        case .footer:
            return 60
        case .photo:
            let tableWidth = tableView.bounds.width
            let ratio = CGFloat(self.presenter.feedPosts[indexPath.section].aspectRatio)
            return (ratio > 0 && ratio.isFinite) ? (ratio * tableWidth) : 0
        case .text:
            let isPressed = isPressedState[indexPath] ?? false
            return isPressed ? UITableView.automaticDimension : defaultCellHeight
        case .video:
            let tableWidth = tableView.bounds.width
            let ratio = self.presenter.feedPosts[indexPath.section].videoAspectRatio
            return (ratio > 0 && ratio.isFinite) ? (ratio * tableWidth) : 0
        }
    }
}

extension FeedTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FeedTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSections = indexPaths.map({ $0.section }).max() else { return }

        switch presenter.type {
        case .newsFeed:
            if maxSections > self.presenter.feedPosts.count - 3 {
                self.presenter.loadNextData(startFrom: self.presenter.nextNews) { news, nextFrom in
                    DispatchQueue.main.async {
                        let startingIndex = self.presenter.feedPosts.count
                        let indexSet = IndexSet(integersIn: startingIndex ..< (startingIndex + news.count))
                        self.presenter.feedPosts.append(contentsOf: news)
                        self.presenter.nextNews = nextFrom

                        for section in startingIndex..<self.presenter.feedPosts.count {
                            for row in 0..<self.presenter.feedPosts[section].rowsCounter.count {
                                let indexPath = IndexPath(row: row, section: section)
                                self.isPressedState[indexPath] = false
                            }
                        }

                        tableView.performBatchUpdates {
                            tableView.insertSections(indexSet, with: .automatic)
                        }
                    }
                }
            }
        case .groupFeed:
            if maxSections > presenter.feedPosts.count - 3 {

                presenter.loadNextData(startFrom: "") { posts, _ in
                    DispatchQueue.main.async {
                        let startingIndex = self.presenter.feedPosts.count
                        let indexSet = IndexSet(integersIn: startingIndex ..< (startingIndex + posts.count))
                        self.presenter.feedPosts.append(contentsOf: posts)

                        for section in startingIndex..<self.presenter.feedPosts.count {
                            for row in 0..<self.presenter.feedPosts[section].rowsCounter.count {
                                let indexPath = IndexPath(row: row, section: section)
                                self.isPressedState[indexPath] = false
                            }
                        }

                        tableView.performBatchUpdates {
                            tableView.insertSections(indexSet, with: .automatic)
                        }
                    }
                }
            }
        case .friendFeed:
            break
        case .none:
            break
        }
    }
}

extension FeedTableViewController: NewsDelegate {
    func buttonTapped(cell: FeedTableViewCellText) {
        if let indexPath = tableView.indexPath(for: cell) {
            isPressedState[indexPath] = !(isPressedState[indexPath] ?? false)
            tableView.performBatchUpdates {
                self.tableView.reloadData()
            }
        }
    }
}

extension FeedTableViewController: FeedFlowInput {
    func updateTableView() {
            hideLoadingIndicator()

            var newState: [IndexPath: Bool] = [:]
            for section in 0..<presenter.feedPosts.count {
                for row in 0..<presenter.feedPosts[section].rowsCounter.count {
                    let ip = IndexPath(row: row, section: section)
                    newState[ip] = isPressedState[ip] ?? false
                }
            }
            isPressedState = newState

            print("Reloading entire table view")
            tableView.reloadData()

            if let ip = pendingIndexPath {
                let validSection = min(ip.section, presenter.feedPosts.count - 1)
                let rowsCount = presenter.feedPosts[validSection].rowsCounter.count
                let validRow = min(ip.row, rowsCount - 1)
                let target = IndexPath(row: validRow, section: validSection)
                tableView.scrollToRow(at: target, at: .top, animated: false)
                pendingIndexPath = nil
            }
        }

    func updateSpecificPost(at index: Int) {
         if index < self.tableView.numberOfSections {
             let currentOffset = self.tableView.contentOffset

             let footerRow = presenter.feedPosts[index].rowsCounter.firstIndex(of: .footer) ?? -1
             if footerRow >= 0 {
                 let indexPath = IndexPath(row: footerRow, section: index)

                 if let cell = self.tableView.cellForRow(at: indexPath) as? FeedFooterSectionCell {
                     cell.configureCell(presenter.feedPosts[index], currentLikeState: presenter.feedPosts[index].likes)
                 }
             }
             self.tableView.setContentOffset(currentOffset, animated: false)
         }
     }
}


extension FeedTableViewController: NewsTableViewCellPhotoDelegate {
    func didTapPhotoCell(images: [String], index: Int) {
        let vc = ExtendedPhotoViewController(arrayOfPhotosFromDB: images, indexOfSelectedPhoto: index)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FeedTableViewController: LikePostDelegate {

    func didLike(in cell: FeedFooterSectionCell?) {
        guard let cell = cell,
              let indexPath = tableView.indexPath(for: cell) else { return }

        let posts = presenter.feedPosts[indexPath.section]
        let currentOffset = tableView.contentOffset

        guard let itemID = posts.postID ?? posts.postWallId,
              let ownerID = posts.sourceId ?? posts.fromID else { return }

        if posts.likes?.canLike == 1 {
            presenter.setLike(itemID: String(itemID), ownerID: String(ownerID))
        } else {
            presenter.removeLike(itemID: String(itemID), ownerID: String(ownerID))
        }
        tableView.setContentOffset(currentOffset, animated: false)
    }
}

extension FeedTableViewController: CommentControlDelegate {
    func didTapComment(in cell: FeedFooterSectionCell?) {
        guard let cell = cell,
              let indexPath = tableView.indexPath(for: cell)
        else {
            print("Failed to get cell or indexPath")
            return
        }
        let posts = presenter.feedPosts[indexPath.section]
        switch self.presenter.type {
        case .friendFeed:
            let commentsVC = CommentsFlowViewBuilder.build(ownerID: posts.fromID ?? 0, postID: posts.postWallId ?? 0)
            present(commentsVC, animated: true)
        case .groupFeed:
            let commentsVC = CommentsFlowViewBuilder.build(ownerID: posts.fromID ?? 0, postID: posts.postWallId ?? 0)
            present(commentsVC, animated: true)
        case .newsFeed:
            let commentsVC = CommentsFlowViewBuilder.build(ownerID: posts.sourceId ?? 0, postID: posts.postID ?? 0)
            present(commentsVC, animated: true)
        case .none:
            break
        }
    }
}



