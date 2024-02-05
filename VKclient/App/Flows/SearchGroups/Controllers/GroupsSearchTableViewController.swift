//
//  GroupsSearchTableViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 25.08.2021.
//

import UIKit
import Combine

class GroupsSearchTableViewController: UIViewController {
    private let presenter: SearchGroupsFlowViewOutput

    private let emptyView = UIView()
    private let label = UILabel()

    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        return table
    }()

    private(set) lazy var search: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = .default
        search.barTintColor = .systemBlue
        
        return search
    }()
    
    init(presenter: SearchGroupsFlowViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        self.navigationItem.titleView = search
        self.configureUI()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(GroupsSearchCell.self, forCellReuseIdentifier: GroupsSearchCell.identifier)
    }

    private func configureUI() {
        self.setupTableView()
        self.setupEmptyView()
    }

    private func setupTableView() {
        self.view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func setupEmptyView() {
        self.tableView.addSubview(emptyView)
        self.emptyView.addSubview(label)
        self.emptyView.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false

        self.emptyView.backgroundColor = .clear
        self.label.text = "Enter a name of the group you want to find"

        NSLayoutConstraint.activate([
         emptyView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
         emptyView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
         emptyView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
         emptyView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

         label.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
         label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
        ])
    }

    private func showEmptyView(isEmpty: Bool) {
        if isEmpty {
            self.emptyView.isHidden = false
        } else {
            self.emptyView.isHidden = true
        }
        self.tableView.reloadData()
    }
}

extension GroupsSearchTableViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GroupsSearchTableViewController: UITableViewDataSource {

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.groupsHolder.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: GroupsSearchCell.identifier,
            for: indexPath) as! GroupsSearchCell

        cell.configureCell(self.presenter.groupsHolder[indexPath.row])

        return cell
    }

}

extension GroupsSearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter.didSearch(searchText)

        self.showEmptyView(isEmpty: searchText.isEmpty)
    }
}

extension GroupsSearchTableViewController: SearchGroupsFlowViewInput {
    func updateTableView() {
        self.tableView.reloadData()
    }
}
