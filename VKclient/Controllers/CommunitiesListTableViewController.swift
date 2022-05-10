//
//  CommunitiesListTableViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 25.08.2021.
//

import UIKit

class CommunitiesListTableViewController: UITableViewController, UISearchBarDelegate {
    
    var groupsHolder = [GroupsObjects]() {
        didSet {
            tableView.reloadData()
        }
    }
    private let network = NetworkService()
    private(set) lazy var search: UISearchBar = {
        let s = UISearchBar()
        s.searchBarStyle = .default
        s.barTintColor = .systemBlue
        
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        self.navigationItem.titleView = search
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsHolder.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath)
        cell.textLabel?.text = groupsHolder[indexPath.row].name
        cell.imageView?.sd_setImage(with: URL(string: groupsHolder[indexPath.row].photo))
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true)}
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
            network.searchForGroups(search: searchText) { [weak self] groups in
                guard let self = self else { return }
                self.groupsHolder = groups
            }
        self.tableView.reloadData()
     
    }
}
