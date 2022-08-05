//
//  NewFriendsTableViewController.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 03.11.2021.
//

import UIKit
import SDWebImage
import RealmSwift

class NewFriendsTableViewController: UIViewController, UISearchBarDelegate {
    
    private(set) lazy var tableView: UITableView = {
        let t = UITableView()
        
        return t
    }()
    
    var friendsFromRealm: Results<UserRealm>?
    var notificationFriends: NotificationToken?
    var friendsNetworkLetters = [[UserObject]]()
    var dictOfUsers: [Character: [UserRealm]] = [:]
    var firstLetters = [Character]()
    private var searchedFilterData: [UserObject] = []
    private var searchedFiltedDataCharacters: [Character] = []
    private var sectionTitles: [Character] = []
    
    private(set) lazy var searchBar: UISearchBar = {
        let s = UISearchBar()
        s.searchBarStyle = .default
        s.sizeToFit()
        s.isTranslucent = true
        s.barTintColor = .green
        
        return s
    }()
    
    private(set) lazy var exitButton: UIBarButtonItem = {
        let b = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(self.buttonPressed))
        b.tintColor = .systemBlue
        
        return b
    }()
    
    //    MARK: - function for TableViewSection
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
    
    private func fetchDataFromNetwork() {
        let friendRequest = GetFriends(constructorPath: "friends.get",
                                       queryItems: [
                                        URLQueryItem(
                                            name: "order",
                                            value: "random"),
                                        URLQueryItem(
                                            name: "fields",
                                            value: "nickname, photo_100")
                                       ])
   
        friendRequest.requestFriends { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.updatesFromRealm()
                self.usersFilteredFromRealm(with: self.friendsFromRealm)
                print("Data has been received")
            case .failure(let requestError):
                switch requestError {
                case .decoderError:
                    print("Decoder error")
                case .requestFailed:
                    print("Request failed")
                case .invalidUrl:
                    print("URL error")
                case .realmError:
                    print("Realm error")
                case .unknownError:
                    print("Unknown error")
                }
            }
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
    
    //    MARK: Sections configure
    func numberOfSections(in tableView: UITableView) -> Int {
        self.firstLetters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let nameFirstLetter = self.firstLetters[section]
        return self.dictOfUsers[nameFirstLetter]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewFriendsViewCell.identifier, for: indexPath) as! NewFriendsViewCell
        //        MARK: Load from Realm
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
        self.firstLetters.map{ String($0) }
    }
    //    MARK: Header of section
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        String(self.firstLetters[section])
        
    }
    
    //    MARK: - SearchBar setup
    
    private func filterFriends(with text: String) {
        guard !text.isEmpty else {
            usersFilteredFromRealm(with: self.friendsFromRealm)
            return
        }
        
        usersFilteredFromRealm(with:self.friendsFromRealm?.filter("firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", text, text))
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
            let VC = PhotoViewController()
            self.navigationController?.pushViewController(VC.self, animated: true)
            
        }
        defer { tableView.deselectRow(at: indexPath, animated: true)}
    }
}

extension NewFriendsTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}



