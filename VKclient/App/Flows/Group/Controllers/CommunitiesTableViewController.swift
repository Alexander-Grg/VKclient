//
//  CommunitiesTableViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 25.08.2021.
//

import UIKit
import SDWebImage
import RealmSwift
import Combine

class CommunitiesTableViewController: UITableViewController, UISearchBarDelegate {
    private var cancellable = Set<AnyCancellable>()
    private let groupService = GroupsService()
    var groupsfromRealm: Results<GroupsRealm>?
    var groupsNotification: NotificationToken?
    var dictOfGroups: [Character: [GroupsRealm]] = [:]
    var firstLetters = [Character]()

    private var groupsHolder = [GroupsObjects]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    private(set) lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = .default
        search.sizeToFit()
        search.isTranslucent = true
        search.barTintColor = .systemBlue

        return search
    }()

    private(set) lazy var addGroupButton: UIBarButtonItem = {
        let barItem = UIBarButtonItem(image: UIImage(systemName: "plus.rectangle.on.rectangle"), style: .plain, target: self, action: #selector(self.addButtonPressed))
        barItem.tintColor = .systemBlue

        return barItem
    }()

    private(set) lazy var exitButton: UIBarButtonItem = {
        let barItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(self.buttonPressed))
        barItem.tintColor = .systemBlue

        return barItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: GroupsTableViewCell.identifier)
        self.fetchDataFromNetwork()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = exitButton
        navigationItem.rightBarButtonItem = addGroupButton
    }

    // MARK: - Private methods

    @objc private func buttonPressed() {
        let loginVC = LoginViewController()
        self.view.window?.rootViewController = loginVC
        self.view.window?.makeKeyAndVisible()
    }

    @objc private func addButtonPressed() {

        let nextVC = GroupsSearchTableViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    private func groupsFilteredFromRealm(with groups: Results<GroupsRealm>?) {
        self.dictOfGroups.removeAll()
        self.firstLetters.removeAll()

        if let filteredGroups = groups {
            for group in filteredGroups {
                guard let dictKey = group.name.first else { continue }
                if var groups = self.dictOfGroups[dictKey] {
                    groups.append(group)
                    self.dictOfGroups[dictKey] = groups
                } else {
                    self.firstLetters.append(dictKey)
                    self.dictOfGroups[dictKey] = [group]
                }
            }
            self.firstLetters.sort()
        }
        tableView.reloadData()
    }

    private func fetchDataFromNetwork() {
        groupService.requestGroups()
            .decode(type: GroupsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] value in
                self?.savingDataToRealm(value.response.items)
                self?.updatesFromRealm()
                self?.groupsFilteredFromRealm(with: self?.groupsfromRealm)
            }
            )
            .store(in: &cancellable)
    }
    
    private func savingDataToRealm(_ data: [GroupsObjects]) {
          do {
              let dataRealm = data.map {GroupsRealm(groups: $0)}
              try? RealmService.save(items: dataRealm)
          }
      }

    private func filterGroups(with text: String) {
        guard !text.isEmpty else {
            groupsFilteredFromRealm(with: self.groupsfromRealm)
            return
        }

        groupsFilteredFromRealm(with: self.groupsfromRealm?.filter("name CONTAINS[cd] %@", text, text))
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterGroups(with: searchText)
    }

    private func updatesFromRealm() {

        groupsfromRealm = try? RealmService.load(typeOf: GroupsRealm.self)

        groupsNotification = groupsfromRealm?.observe(on: .main, { realmChange in
            switch realmChange {
            case .initial(let objects):
                if objects.count > 0 {
                    self.tableView.reloadData()
                }
                print(objects)

            case let .update(_, deletions, insertions, modifications ):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}),
                                          with: .none)
                self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}),
                                          with: .none)
                self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                          with: .none)
                self.tableView.endUpdates()

            case .error(let error):
                print(error)

            }
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        groupsNotification?.invalidate()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nameFirstLetter = self.firstLetters[section]
        return self.dictOfGroups[nameFirstLetter]?.count ?? 0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        self.firstLetters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GroupsTableViewCell.identifier,
            for: indexPath) as? GroupsTableViewCell
        else { return UITableViewCell()}

        let firstLetter = self.firstLetters[indexPath.section]
        if let groups = self.dictOfGroups[firstLetter] {
            cell.configureCell(groups: groups[indexPath.row])
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88.0
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        self.firstLetters.map { String($0) }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        String(self.firstLetters[section])
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do { tableView.deselectRow(at: indexPath, animated: true)}
    }
}
