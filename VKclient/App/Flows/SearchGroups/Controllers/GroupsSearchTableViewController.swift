//
//  GroupsSearchTableViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 25.08.2021.
//

import UIKit

class GroupsSearchTableViewController: UITableViewController, UISearchBarDelegate {

    var groupsHolder = [GroupsObjects]()
    private(set) lazy var search: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = .default
        search.barTintColor = .systemBlue

        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        self.navigationItem.titleView = search
        self.tableView.register(GroupsSearchCell.self, forCellReuseIdentifier: GroupsSearchCell.identifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsHolder.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GroupsSearchCell.identifier,
            for: indexPath) as? GroupsSearchCell
        else { return UITableViewCell() }
        cell.configureCell(groupsHolder[indexPath.row])

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true)}
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let requestSearch = GetGroupSearch(
            constructorPath: "groups.search",
            queryItems: [
                URLQueryItem(name: "sort", value: "6"),
                URLQueryItem(name: "type", value: "group"),
                URLQueryItem(name: "q", value: searchText),
                URLQueryItem(name: "count", value: "20")
            ])

        if searchText.isEmpty {
            self.groupsHolder.removeAll()
            self.tableView.reloadData()
        } else {

            requestSearch.request { [weak self] groups in
                guard let self = self else { return }
                self.groupsHolder = groups

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }

    }
}
