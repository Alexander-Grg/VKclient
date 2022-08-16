//
//  NewFriendsTableViewController.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 03.11.2021.
//

import UIKit
import SDWebImage
import RealmSwift
import Combine

class NewFriendsTableViewController: UIViewController, UISearchBarDelegate {
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    private var cancellable = Set<AnyCancellable>()
    private let userService = UserService()
    var friendsFromRealm: Results<UserRealm>?
    var notificationFriends: NotificationToken?
    var dictOfUsers: [Character: [UserRealm]] = [:]
    var firstLetters = [Character]()
    var networkValue: [UserObject] = []

    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
            searchBar.searchBarStyle = .default
            searchBar.sizeToFit()
            searchBar.isTranslucent = true
            searchBar.barTintColor = .green

        return searchBar
    }()

    private(set) lazy var exitButton: UIBarButtonItem = {
        let barItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(self.buttonPressed))
        barItem.tintColor = .systemBlue

        return barItem
    }()

// MARK: - Function for tableView sections
    private func usersFilteredFromRealm(with friends: Results<UserRealm>?) {
        self.dictOfUsers.removeAll()
        self.firstLetters.removeAll()

        if let filteredFriends = friends {
            for user in filteredFriends {
                guard let dictKey = user.lastName.first else { continue }
                if var users = self.dictOfUsers[dictKey] {
                    users.append(user)
                    self.dictOfUsers[dictKey] = users
                } else {
                    self.firstLetters.append(dictKey)
                    self.dictOfUsers[dictKey] = [user]
                }
            }
            self.firstLetters.sort()
        }
        tableView.reloadData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        fetchDataFromNetwork()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()

        searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(NewFriendsViewCell.self, forCellReuseIdentifier: NewFriendsViewCell.identifier)
        navigationItem.titleView = searchBar
        navigationItem.titleView?.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = exitButton
        fetchDataFromNetwork()
    }

     func fetchDataFromNetwork() {
         userService.requestUsers()
             .decode(type: UserResponse.self, decoder: JSONDecoder())
             .receive(on: DispatchQueue.main)
             .sink(receiveCompletion: { [weak self] error in
                 self?.friendsFromRealm = nil
                 print(error)
             }, receiveValue: { [weak self] value in
                 self?.savingDataToRealm(value.response.items)
                 self?.updatesFromRealm()
                 self?.usersFilteredFromRealm(with: self?.friendsFromRealm)
             }
             )
             .store(in: &cancellable)
    }
    
   private func savingDataToRealm(_ data: [UserObject]) {
         do {
             let dataRealm = data.map {UserRealm(user: $0)}
             try? RealmService.save(items: dataRealm)
         }
     }

    private func updatesFromRealm() {
        friendsFromRealm = try? RealmService.get(type: UserRealm.self)

        notificationFriends = friendsFromRealm?.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial:
                break
            case .update:
                self.tableView.reloadData()
            case let .error(error):
                print(error)
            }
        }
    }

    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

    }

    @objc private func buttonPressed() {
        let loginVC = LoginViewController()
        self.view.window?.rootViewController = loginVC
        self.view.window?.makeKeyAndVisible()
    }
}

extension NewFriendsTableViewController: UITableViewDataSource {

    // MARK: Sections configure
    func numberOfSections(in tableView: UITableView) -> Int {
        self.firstLetters.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let nameFirstLetter = self.firstLetters[section]
        return self.dictOfUsers[nameFirstLetter]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewFriendsViewCell.identifier,
            for: indexPath) as? NewFriendsViewCell
        else { return UITableViewCell() }
        // MARK: Load from Realm
        let firstLetter = self.firstLetters[indexPath.section]
        if let users = self.dictOfUsers[firstLetter] {
            cell.configure(users[indexPath.row])
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88.0
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        self.firstLetters.map { String($0) }
    }
    // MARK: Header of section

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        String(self.firstLetters[section])

    }

    // MARK: - SearchBar setup

    private func filterFriends(with text: String) {
        guard !text.isEmpty else {
            usersFilteredFromRealm(with: self.friendsFromRealm)
            return
        }

        usersFilteredFromRealm(with: self.friendsFromRealm?.filter("firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", text, text))
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterFriends(with: searchText)
    }
}

extension NewFriendsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let firstLetter = self.firstLetters[indexPath.section]
        if let users = self.dictOfUsers[firstLetter] {
            let userID = users[indexPath.row].id
            Session.instance.friendID = userID
            let viewController = PhotoViewController()
            self.navigationController?.pushViewController(viewController.self, animated: true)

        }
        defer { tableView.deselectRow(at: indexPath, animated: true)}
    }
}

extension NewFriendsTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
