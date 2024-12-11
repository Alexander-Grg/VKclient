//
//  NewsTableViewController.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 16.09.2021.
//

import UIKit

final class NewsTableViewController: UIViewController {
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        
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
        
        configRefreshControl()
        
        self.tableView.register(NewsHeaderSection.self, forCellReuseIdentifier: NewsHeaderSection.identifier)
        self.tableView.register(NewsTableViewCellPost.self, forCellReuseIdentifier: NewsTableViewCellPost.identifier)
        self.tableView.register(NewsTableViewCellPhoto.self, forCellReuseIdentifier: NewsTableViewCellPhoto.identifier)
        self.tableView.register(NewsFooterSection.self, forCellReuseIdentifier: NewsFooterSection.identifier)
        
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
        self.presenter.newsPost.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.presenter.newsPost[indexPath.section].rowsCounter[indexPath.row] {
        case .header:
            return 75
        case .footer:
            return 40
        case .photo:
            let tableWidth = tableView.bounds.width
            let ratio = self.presenter.newsPost[indexPath.section].aspectRatio
            let newsCGfloatRatio = CGFloat(ratio)
            return newsCGfloatRatio * tableWidth
        case .text:
            let isPressed = isPressedState[indexPath] ?? false
              return isPressed ? UITableView.automaticDimension : defaultCellHeight
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

                    tableView.beginUpdates()
                    tableView.insertSections(indexSet, with: .automatic)
                    tableView.endUpdates()

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
            tableView.beginUpdates()
            tableView.endUpdates()
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
