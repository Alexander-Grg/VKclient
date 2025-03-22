//
//  NewFriendsTableViewController.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 03.11.2021.
//  Copyright © 2021–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
import SDWebImage

final class NewFriendsTableViewController: UIViewController, UISearchBarDelegate {
    
    private let presenter: FriendsFlowViewOutput
    
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(
            NewFriendsViewCell.self,
            forCellReuseIdentifier: NewFriendsViewCell.identifier
        )

        return table
    }()
    
    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .default
        searchBar.sizeToFit()
        searchBar.isTranslucent = true
        searchBar.barTintColor = .green
        searchBar.delegate = self

        return searchBar
    }()
    
    private(set) lazy var exitButton: UIBarButtonItem = {
        let barItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(self.buttonDidPress))
        
        barItem.tintColor = .systemBlue
        
        return barItem
    }()
    
    //    MARK: - LifeCycle
    init(presenter: FriendsFlowViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        navigationItem.titleView = searchBar
        navigationItem.titleView?.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = exitButton
        self.presenter.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.dataUpdates()
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

extension NewFriendsTableViewController: UITableViewDataSource {
    
    // MARK: Sections configure
    func numberOfSections(in tableView: UITableView) -> Int {
        self.presenter.firstLetters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nameFirstLetter = self.presenter.firstLetters[section]
        return self.presenter.dictOfUsers[nameFirstLetter]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewFriendsViewCell.identifier,
            for: indexPath) as? NewFriendsViewCell
        else { return UITableViewCell() }
        // MARK: Load from Realm
        let firstLetter = self.presenter.firstLetters[indexPath.section]
        if let users = self.presenter.dictOfUsers[firstLetter] {
            cell.configure(users[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88.0
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        self.presenter.firstLetters.map { String($0) }
    }
    // MARK: Header of section
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        String(self.presenter.firstLetters[section])
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter.didSearch(search: searchText)
    }
}

extension NewFriendsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.presenter.goNextScreen(index: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewFriendsTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension NewFriendsTableViewController: FriendsFlowViewInput {
    func updateTableView() {
        self.tableView.reloadData()
    }
    
    @objc func buttonDidPress() {
        self.presenter.logout()
    }
}

