//
//  GroupsSearchTableViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 25.08.2021.
//

import UIKit
import Combine

class GroupsSearchTableViewController: UITableViewController, UISearchBarDelegate {
    private var cancellable = Set<AnyCancellable>()
    private let groupsSearchService = GroupSearchService()
    
    var groupsHolder = [GroupsObjects]() {
        didSet {
            self.tableView.reloadData()
        }
    }
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
        let cell = tableView.dequeueReusableCell(
            withIdentifier: GroupsSearchCell.identifier,
            for: indexPath) as! GroupsSearchCell
        
        cell.configureCell(groupsHolder[indexPath.row])
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true)}
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.groupsHolder.removeAll()
        } else {
            groupsSearchService.requestGroupsSearch(search: searchText)
                .decode(type: GroupsResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] error in
                    print(error)
                }, receiveValue: { [weak self] value in
                    self?.groupsHolder = value.response.items
                }
                )
                .store(in: &cancellable)
        }
    }
}
