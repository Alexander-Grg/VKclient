//
//  CommunitiesTableViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 25.08.2021.
//

import UIKit
import SDWebImage

class CommunitiesTableViewController: UITableViewController, UISearchBarDelegate {
    private let presenter: GroupsFlowViewOutput
    
    private(set) lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = .default
        search.sizeToFit()
        search.isTranslucent = true
        search.barTintColor = .systemBlue

        return search
    }()

    private(set) lazy var addGroupButton: UIBarButtonItem = {
        let barItem = UIBarButtonItem(image: UIImage(systemName: "plus.rectangle.on.rectangle"), style: .plain, target: self, action: #selector(self.addGroupButtonPressed))
        barItem.tintColor = .systemBlue

        return barItem
    }()

    private(set) lazy var exitButton: UIBarButtonItem = {
        let barItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(self.exitButtonPressed))
        barItem.tintColor = .systemBlue

        return barItem
    }()
    
    init(presenter: GroupsFlowViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: GroupsTableViewCell.identifier)
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = exitButton
        navigationItem.rightBarButtonItem = addGroupButton
        self.presenter.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.fetchData()
        self.presenter.dataUpdates()
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter.didSearch(search: searchText)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nameFirstLetter = self.presenter.firstLetters[section]
        return self.presenter.dictOfGroups[nameFirstLetter]?.count ?? 0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        self.presenter.firstLetters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GroupsTableViewCell.identifier,
            for: indexPath) as? GroupsTableViewCell
        else { return UITableViewCell()}

        let firstLetter = self.presenter.firstLetters[indexPath.section]
        if let groups = self.presenter.dictOfGroups[firstLetter] {
            cell.configureCell(groups: groups[indexPath.row])
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88.0
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        self.presenter.firstLetters.map { String($0) }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        String(self.presenter.firstLetters[section])
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do { tableView.deselectRow(at: indexPath, animated: true)}
        presenter.goDetailGroupScreen(index: indexPath)
    }
}

extension CommunitiesTableViewController: GroupsFlowViewInput {
    
    func updateTableView() {
        self.tableView.reloadData()
    }

    func toTheGroupsDetail() {
        
    }

    @objc func exitButtonPressed() {
        self.presenter.exit()
    }

    @objc func addGroupButtonPressed() {
        self.presenter.goNextGroupSearchScreen()
    }
}
