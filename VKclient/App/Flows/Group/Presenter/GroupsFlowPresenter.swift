//
//  GroupsFlowPresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//

import Foundation
import UIKit
import RealmSwift
import Combine
import KeychainAccess

protocol GroupsFlowViewInput: AnyObject {
     var tableView: UITableView { get set }
     func reloadData()
}

protocol GroupsFlowViewOutput: AnyObject {
    var dictOfGroups: [Character: [GroupsRealm]] { get }
    var firstLetters: [Character] { get }
    func removeGroup(id: Int, index: IndexPath)
    func didSearch(search: String)
    func fetchAndUpdateData()
    func exit()
    func goNextGroupSearchScreen()
    func goDetailGroupScreen(index: IndexPath)
}

final class GroupsFlowPresenter {
    @Injected(\.groupsService) var groupService: GroupsServiceProtocol
    @Injected(\.groupActionsService) var groupActionService: GroupsActionProtocol
    @Injected(\.realmService) var realmService: RealmServiceProtocol
    private var cancellable = Set<AnyCancellable>()
    var groupsfromRealm: Results<GroupsRealm>?
    var groupsNotification: NotificationToken?
    var dictOfGroups: [Character: [GroupsRealm]] = [:]
    var firstLetters = [Character]()
    weak var viewInput: (UIViewController & GroupsFlowViewInput)?

    private func groupsFilteredFromRealm(with groups: Results<GroupsRealm>?) {
        guard let filteredGroups = groups else { return }
        dictOfGroups.removeAll()
        firstLetters.removeAll()

        filteredGroups.forEach { group in
            guard let dictKey = group.name.first else { return }
            var groupsForLetter = dictOfGroups[dictKey, default: []]
            groupsForLetter.append(group)
            dictOfGroups[dictKey] = groupsForLetter
            if !firstLetters.contains(dictKey) {
                firstLetters.append(dictKey)
            }
        }

        firstLetters.sort()
        self.viewInput?.reloadData()
    }

    private func getIndexAndSectionForNewObject(indeces: [Int], groups: Results<GroupsRealm>) -> (newIndex: Int, newSection: Int)? {
        for index in indeces {
            let newObject = groups[index]

            guard let newObjectLetter = newObject.name.first,
                  let groupArray = dictOfGroups[newObjectLetter],
                  let newIndex = groupArray.firstIndex(where: { $0 == newObject }) else {
                continue
            }

            let newSection = self.firstLetters.firstIndex(of: newObjectLetter) ?? 0
            return (newIndex, newSection)
        }

        return nil
    }

    private func fetchDataFromNetworkAndSaveToRealm() {
        groupService.requestGroups()
            .decode(type: GroupsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Fetching groups from network is finished")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.savingDataToRealm(value.response.items)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.fetchAndFilterDataFromRealm()
                    self.viewInput?.reloadData()
                }
            }
            )
            .store(in: &cancellable)
    }
    
    private func savingDataToRealm(_ data: [GroupsObjects]) {
          do {
              let dataRealm = data.map {GroupsRealm(groups: $0)}
              try self.realmService.save(items: dataRealm, configuration: .defaultConfiguration, update: .modified)
          } catch {
              print("Saving to Realm failed")
          }
      }

    private func removeDataFromRealm(_ data: Results<GroupsRealm>?) {
        guard let objectToDelete = data else { return }
        do {
            try self.realmService.delete(object: objectToDelete)
        } catch {
            print("Deletion from Realm failed")
        }
    }

    private func fetchAndFilterDataFromRealm() {
        do {
            self.groupsfromRealm = try self.realmService.get(type: GroupsRealm.self, configuration: .defaultConfiguration)
        } catch {
            print("Download from Realm failed")
        }
        self.groupsFilteredFromRealm(with: self.groupsfromRealm)
    }

    private func filterGroups(with text: String) {
        guard !text.isEmpty else {
            groupsFilteredFromRealm(with: self.groupsfromRealm)
            return
        }
        self.groupsFilteredFromRealm(with: self.groupsfromRealm?.filter("name CONTAINS[cd] %@", text, text))
    }

    private func insertRow(index: Int, section: Int) {
        guard let tableView = viewInput?.tableView
        else { return }
        tableView.performBatchUpdates {
            let indexPath = IndexPath(item: index, section: section)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }

    private func deleteRow(at index: Int, section: Int) {
        guard let tableView = viewInput?.tableView else { return }
        tableView.performBatchUpdates {
            let indexPath = IndexPath(item: index, section: section)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    private func updateRow(at index: Int, section: Int) {
        guard let tableView = viewInput?.tableView else { return }

        let indexPath = IndexPath(item: index, section: section)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    private func updateRealmObjects() {
        self.fetchDataFromNetworkAndSaveToRealm()
        groupsNotification = groupsfromRealm?.observe(on: .main, { [weak self] changes in
            guard let self = self
            else { return }
            switch changes {
            case .initial:
                self.fetchAndFilterDataFromRealm()
                viewInput?.tableView.reloadData()
            case let .update(updatedGroupsRealm, deletions, insertions, modifications):
                if deletions.count > 0 {
                    guard let (index, section) = self.getIndexAndSectionForNewObject(indeces: deletions, groups: updatedGroupsRealm)
                    else { return }
                    self.deleteRow(at: index, section: section)
                }

                if insertions.count > 0 {
                    guard let (index, section) = self.getIndexAndSectionForNewObject(indeces: insertions, groups: updatedGroupsRealm)
                    else { return }
                        self.insertRow(index: index, section: section)
                }

                if modifications.count > 0 {
                    guard let (index, section) = self.getIndexAndSectionForNewObject(indeces: modifications, groups: updatedGroupsRealm)
                    else { return }
                    self.updateRow(at: index, section: section)
                }
                viewInput?.tableView.reloadData()
            case let .error(error):
                print(error)
            }
        })
    }
    
    private func toTheGroupSearch() {
        let nextVC = SearchGroupsFlowBuilder.build(updateDelegate: self)
        self.viewInput?.navigationController?.pushViewController(nextVC, animated: true)
    }

    private func toTheExactGroup(index: IndexPath) {
        let firstLetter = self.firstLetters[index.section]
        if let groups = self.dictOfGroups[firstLetter] {
            let nextVC = GroupsDetailModuleBuilder.build(groups[index.row], joinGroupDelegate: self, removeGroupDelegate: self)

            self.viewInput?.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    private func alertOfExit() {
        let alertController = UIAlertController(title: "Exit", message: "Do you really want to leave?", preferredStyle: .alert)

        let logoutAction = UIAlertAction(title: "Sign out VK account", style: .default) { [weak self] _ in
            guard let self = self else { return }
            do {
                try Keychain().remove("token")
            } catch let error as NSError {
                print("\(error.localizedDescription)")
            }
                    let loginVC = LoginViewController()
            self.viewInput?.view.window?.rootViewController = loginVC
            self.viewInput?.view.window?.makeKeyAndVisible()
        }

        let toTheLoginScreenAction = UIAlertAction(title: "Back to the login page", style: .default) { action in
                    let loginVC = LoginViewController()
            self.viewInput?.view.window?.rootViewController = loginVC
            self.viewInput?.view.window?.makeKeyAndVisible()
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)


        alertController.addAction(logoutAction)
        alertController.addAction(toTheLoginScreenAction)
        alertController.addAction(cancel)

        viewInput?.present(alertController, animated: true)
    }

    private func leaveGroupRequest(id: Int, index: IndexPath) {
        groupActionService.requestGroupsLeave(id: id)
            .decode(type: GroupsActionsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (error) in
                print("Leave group request is failed: \(String(describing: error))")
            }, receiveValue: { (result) in
                if result.response == 1 {
                    print("Leave group is succesful")
                    if let groups = self.groupsfromRealm {
                        let data = groups.filter("id == %@", id)
                        self.removeDataFromRealm(data)
                        self.fetchAndUpdateData()
                    }
                }
            })
            .store(in: &cancellable)
    }

    private func removeSpecificGroup(id: Int) {
           if let groups = self.groupsfromRealm {
               let data = groups.filter("id == %@", id)
               self.removeDataFromRealm(data)
               self.fetchAndUpdateData()
           }
    }

    private func logout() {
        alertOfExit()
    }
}

extension GroupsFlowPresenter: GroupsFlowViewOutput {

    func removeGroup(id: Int, index: IndexPath) {
        self.leaveGroupRequest(id: id, index: index)
    }

    func fetchAndUpdateData() {
        self.fetchAndFilterDataFromRealm()
        if self.groupsfromRealm?.isEmpty == true { // If no data, fetch from network
             self.fetchDataFromNetworkAndSaveToRealm()
         }
        self.updateRealmObjects()
    }

    func didSearch(search: String) {
        self.filterGroups(with: search)
        self.viewInput?.reloadData()
    }
    
    func exit() {
        self.logout()
    }
    
    func goNextGroupSearchScreen() {
        self.toTheGroupSearch()
    }

    func goDetailGroupScreen(index: IndexPath) {
        self.toTheExactGroup(index: index)
    }
}

extension GroupsFlowPresenter: JoinGroupDelegate {
    func joinGroupDelegation(_ isJoined: Bool) {
        if isJoined {
            self.fetchAndUpdateData()
            viewInput?.reloadData()
        }
    }
}

extension GroupsFlowPresenter: RemoveGroupDelegate {
    func removeGroup(_ groupId: Int?) {
        guard let id = groupId else { return }
        self.removeSpecificGroup(id: id)
    }
}

extension GroupsFlowPresenter: SearchGroupsUpdateDelegate {
    func didAddGroup() {
        self.fetchAndUpdateData()
    }
}
