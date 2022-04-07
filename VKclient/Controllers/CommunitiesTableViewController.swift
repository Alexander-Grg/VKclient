//
//  CommunitiesTableViewController.swift
//  ProjectTestLocalUI
//
//  Created by Alexander Grigoryev on 25.08.2021.
//

import UIKit
import SDWebImage
import RealmSwift

class CommunitiesTableViewController: UITableViewController {
   
    @IBOutlet var addGroup: UIBarButtonItem!
    
    var groupsfromRealm: Results<GroupsRealm>?
    var groupsNotification: NotificationToken?
   private let networkService = NetworkService()

    private var groupsHolder = [GroupsObjects]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "myGroupsCells")
        self.fetchDataFromNetwork()
        self.updatesFromRealm()
      
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.updatesFromRealm()
//    }
    
//    MARK: Function for OPERATION
    private func fetchDataFromNetwork() {
        networkService.fetchingGroups { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
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
    
//    MARK: Realm notification updates
        private func updatesFromRealm() {
    
            groupsfromRealm = try? RealmService.load(typeOf: GroupsRealm.self)
    
            groupsNotification = groupsfromRealm?.observe(on: .main, { realmChange in
                switch realmChange {
                case .initial(let objects):
                    if objects.count > 0 {
                        self.tableView.reloadData()
                    }
                    print(objects)
    
                case let .update(groupsRealm, deletions, insertions, modifications ):
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
        groupsfromRealm?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myGroupsCells", for: indexPath) as! GroupsTableViewCell
        guard let groups = groupsfromRealm else { return cell }
        cell.configure(groups: groups[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do { tableView.deselectRow(at: indexPath, animated: true)}
        
    }
}
