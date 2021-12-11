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
    var groupsfromRealm: Results<GroupsRealm>? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var groupsNotification: NotificationToken?
    private let network = NetworkService()
    private let token = Session.instance.token
    private var groupsHolder = [GroupsObjects]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        //                loadGroupsFromNetwork()
        loadFromDB()
    }
    
    private func loadFromDB() {
        network.loadGroups(token: token)
        
        groupsfromRealm = try? RealmService.load(typeOf: GroupsRealm.self)
        
        groupsNotification = groupsfromRealm?.observe(on: .main, { realmChange in
            switch realmChange {
            case .initial(let objects):
                if objects.count > 0 {
                    //                self.groupsfromRealm = objects
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
    //        private func loadGroupsFromNetwork() {
    //            network.loadGroups(token: token) { [weak self] groupsHolder in
    //                guard let self = self else { return }
    //                self.groupsHolder = groupsHolder
    //            }
    //            tableView.reloadData()
    //        }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        groupsHolder.count
        groupsfromRealm?.count ?? 0
        //        return myCommunities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myGroupsCells", for: indexPath)
        //        cell.textLabel?.text = groupsHolder[indexPath.row].name
        //        cell.imageView?.sd_setImage(with: URL(string: groupsHolder[indexPath.row].photo))
        cell.textLabel?.text = groupsfromRealm?[indexPath.row].name
        cell.imageView?.sd_setImage(with: URL(string: (groupsfromRealm?[indexPath.row].photo)!))
        //        let groups = myCommunities[indexPath.row]
        //        cell.imageView?.image = groups.image
        //        cell.textLabel?.text = groups.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do { tableView.deselectRow(at: indexPath, animated: true)}
        
    }
    
    //    MARK: Method to add froup from all groups screen
    //    @IBAction func addGroup(_ segue: UIStoryboardSegue) {
    //        guard
    //            segue.identifier == "addGroup",
    //            let sourceController = segue.source as? CommunitiesListTableViewController,
    //            let indexPath = sourceController.tableView.indexPathForSelectedRow
    //        else {
    //            return
    //        }
    //        let group = sourceController.communitiesAll[indexPath.row]
    //        if !myCommunities.contains(where: { $0.name == group.name }) {
    //            myCommunities.append(group)
    //            tableView.reloadData()
    //        }
    //    }
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            myCommunities.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        }
    //    }
}


