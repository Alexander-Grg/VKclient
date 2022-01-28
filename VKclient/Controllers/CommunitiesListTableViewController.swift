//
//  CommunitiesListTableViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 25.08.2021.
//

import UIKit

class CommunitiesListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var search: UISearchBar!
    var isSearching: Bool = false
    var groupsHolder2 = [SearchedObjects]() {
        didSet {
            tableView.reloadData()
        }
    }
    private let token = Session.instance.token
    private let network = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsHolder2.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath)
        cell.textLabel?.text = groupsHolder2[indexPath.row].name
        cell.imageView?.sd_setImage(with: URL(string: groupsHolder2[indexPath.row].photo))
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do { tableView.deselectRow(at: indexPath, animated: true)}
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        let proxy = ProxyNetworkServiceGroupSearch(networkService: network)
        proxy.SearchForGroups(token: token, search: searchText) { [weak self] groupsHolder2 in
            guard let self = self else { return }
            self.groupsHolder2 = groupsHolder2
        }
//        network.SearchForGroups(token: token, search: searchText) { [weak self] groupsHolder2 in
//            guard let self = self else { return }
//            self.groupsHolder2 = groupsHolder2
//        }
        tableView.reloadData()
    }
}
