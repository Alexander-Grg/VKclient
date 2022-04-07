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
    private var searchedFilterData: [UserObject] = []
    private var searchedFiltedDataCharacters: [Character] = []
    private var sectionTitles: [Character] = []
    private var isSearching: Bool = false
    var friendsFromRealm: Results<UserRealm>?
    var notificationFriends: NotificationToken?
    var friendsNetworkLetters = [[UserObject]]()
    var dictOfUsers: [Character: [UserRealm]] = [:]
    var firstLetters = [Character]()
    
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
        searchBar.delegate = self
        fetchDataFromNetwork()
    }
    
    private func fetchDataFromNetwork() {
        networkService.loadFriends { [weak self] result in
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
    
    //        MARK: - Segue to transfer photos to the PhotoCollectionView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "goToAlbum",
            let imageDestination = segue.destination as? PhotoViewController,
            let indexPath = tableView.indexPathForSelectedRow
        else { return }
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
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete,
//           let friendToDelete = friendsFromRealm?[indexPath.row] {
//            do {
//                let realm = try Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
//                try realm.write {
//                    realm.delete(friendToDelete)
//                }
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            } catch {
//                print(error)
//            }
//        }
//    }
}
extension NewFriendsTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


