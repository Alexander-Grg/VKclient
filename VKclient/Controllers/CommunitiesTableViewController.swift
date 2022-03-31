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
//    MARK: Property for OPERATION
    let myQueue: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 4
        q.name = "asych.groups.load.parsing.savingToRealm.operation"
        q.qualityOfService = .userInitiated
        return q
    }()
    
    var groupsfromRealm: Results<GroupsRealm>? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var groupsNotification: NotificationToken?
    private let token = Session.instance.token

    private var groupsHolder = [GroupsObjects]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "myGroupsCells")
        asyncOperationGroups()
        updatesFromRealm()
    }
    
//    MARK: Function for OPERATION
    private func asyncOperationGroups() {
        let networkOperation = NetworkGroupsAsyncOperation(url: URL(string: "https://api.vk.com/method/groups.get")!)
        myQueue.addOperation(networkOperation)

        let parsingOperation = ParsingData()
        parsingOperation.addDependency(networkOperation)
        myQueue.addOperation(parsingOperation)

        let saveToRealm = SavingGroupsToRealmAsyncOperation()
        saveToRealm.addDependency(parsingOperation)
        myQueue.addOperation(saveToRealm)
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
        cell.configure(from: groups[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do { tableView.deselectRow(at: indexPath, animated: true)}
        
    }
}
