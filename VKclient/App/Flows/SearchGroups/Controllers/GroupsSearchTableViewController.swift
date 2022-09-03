//
//  GroupsSearchTableViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 25.08.2021.
//

import UIKit
import Combine

class GroupsSearchTableViewController: UITableViewController, UISearchBarDelegate {
    private let presenter: SearchGroupsFlowViewOutput
    
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
        self.tableView.register(GroupsSearchCell.self, forCellReuseIdentifier: GroupsSearchCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.groupsHolder.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: GroupsSearchCell.identifier,
            for: indexPath) as! GroupsSearchCell
        
        cell.configureCell(self.presenter.groupsHolder[indexPath.row])
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true)}
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter.didSearch(searchText)
    }
}

extension GroupsSearchTableViewController: SearchGroupsFlowViewInput {
    func updateTableView() {
        self.tableView.reloadData()
    }
}
