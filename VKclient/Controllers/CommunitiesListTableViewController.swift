//
//  CommunitiesListTableViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 25.08.2021.
//

import UIKit

class CommunitiesListTableViewController: UITableViewController, UISearchBarDelegate {
    
    var groupsHolder = [GroupsObjects]() 
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
        self.tableView.register(CommunityListCustomCell.self, forCellReuseIdentifier: CommunityListCustomCell.reusedIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsHolder.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath) as! CommunityListCustomCell
        cell.configureCell(groupsHolder[indexPath.row])
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true)}
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchText.isEmpty {
            self.groupsHolder.removeAll()
            self.tableView.reloadData()
        } else {
            network.searchForGroups(search: searchText) { [weak self] groups in
                guard let self = self else { return }
                self.groupsHolder = groups
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
     
    }
}



