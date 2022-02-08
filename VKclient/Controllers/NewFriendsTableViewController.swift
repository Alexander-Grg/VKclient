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
    
    @IBOutlet var alphabetControl: AlphabetControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet private var searchBar: UISearchBar!
    private let networkService = NetworkService()
    private let token = Session.instance.token
    private var searchedFilterData: [UserObject] = []
    private var searchedFiltedDataCharacters: [Character] = []
    private var sectionTitles: [Character] = []
    private var isSearching: Bool = false
    var friendsFromRealm: Results<UserRealm>? = try? RealmService.get(type: UserRealm.self)
    var notificationFriends: NotificationToken?
    var friendsNetworkLetters = [[UserObject]]()
    var dictOfUsers: [Character: [UserRealm]] = [:]
    var firstLetters = [Character]()
    
    //    MARK: - function for TableViewHeaderSection
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
        searchBar.delegate = self
        loadFromDB()
    }
    
    private func loadFromDB() {
//        networkService.loadFriends(token: token)
        tableView.reloadData()
       
        
        friendsFromRealm = try? RealmService.load(typeOf: UserRealm.self)
        
        notificationFriends = friendsFromRealm?.observe(on: .main, { realmChange in
            switch realmChange {
            case .initial(let objects):
                if objects.count > 0 {
                    self.usersFilteredFromRealm(with: self.friendsFromRealm)
                    //                self.groupsfromRealm = objects
                    self.tableView.reloadData()
                }
                print(objects)
                
            case let .update(_, deletions, insertions, modifications ):
                self.tableView.beginUpdates()
                self.usersFilteredFromRealm(with: self.friendsFromRealm)
                self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}),
                                          with: .none)
                self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}),
                                          with: .none)
                self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                          with: .none)
                self.tableView.endUpdates()
                self.tableView.reloadData()
                
            case .error(let error):
                print(error)
                
            }
        })
    }
    
    //        MARK: - Segue to transfer photos to the PhotoCollectionView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "goToAlbum",
            let imageDestination = segue.destination as? PhotoViewController,
            let indexPath = tableView.indexPathForSelectedRow
        else { return }
        
    //        MARK: Load from Realm
        
        let firstLetter = self.firstLetters[indexPath.section]
        if let users = self.dictOfUsers[firstLetter] {
            let user = users[indexPath.row]
            imageDestination.friendID = user.id
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewFriendsCell", for: indexPath) as! NewFriendsViewCell
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
        defer { tableView.deselectRow(at: indexPath, animated: true)}
    }
}
extension NewFriendsTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


