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
    func updateTableView()
}

protocol GroupsFlowViewOutput: AnyObject {
    var dictOfGroups: [Character: [GroupsRealm]] { get }
    var firstLetters: [Character] { get }
    func fetchData()
    func dataUpdates()
    func didSearch(search: String)
    func exit()
    func goNextGroupSearchScreen()
    func goDetailGroupScreen(index: IndexPath)
}

final class GroupsFlowPresenter {
    @Injected (\.groupsService) var groupService: GroupsServiceProtocol
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
         viewInput?.updateTableView()
    }

    private func fetchDataFromNetwork() {
        groupService.requestGroups()
            .decode(type: GroupsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.savingDataToRealm(value.response.items)
                self.loadDataFromRealm()
                self.groupsFilteredFromRealm(with: self.groupsfromRealm)
            }
            )
            .store(in: &cancellable)
    }
    
    private func savingDataToRealm(_ data: [GroupsObjects]) {
          do {
              let dataRealm = data.map {GroupsRealm(groups: $0)}
              try RealmService.save(items: dataRealm)
          } catch {
              print("Saving to Realm failed")
          }
      }
    
    private func loadDataFromRealm() {
        do {
            self.groupsfromRealm = try RealmService.get(type: GroupsRealm.self)
        } catch {
            print("Download from Realm failed")
        }
    }

    private func filterGroups(with text: String) {
        guard !text.isEmpty else {
            groupsFilteredFromRealm(with: self.groupsfromRealm)
            return
        }
        self.groupsFilteredFromRealm(with: self.groupsfromRealm?.filter("name CONTAINS[cd] %@", text, text))
    }

    private func updatesFromRealm() {
        groupsNotification = groupsfromRealm?.observe(on: .main, { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial:
                break
            case .update:
                self.viewInput?.updateTableView()
                self.loadDataFromRealm()
                self.groupsFilteredFromRealm(with: self.groupsfromRealm)
            case let .error(error):
                print(error)
            }
        })
    }
    
    private func toTheGroupSearch() {
        let nextVC = SearchGroupsFlowBuilder.build()
        self.viewInput?.navigationController?.pushViewController(nextVC, animated: true)
    }

    private func toTheExactGroup(index: IndexPath) {
        let firstLetter = self.firstLetters[index.section]
        if let groups = self.dictOfGroups[firstLetter] {
            let nextVC = GroupsDetailModuleBuilder.build(groups[index.row])
            self.viewInput?.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    private func alertOfExit() {
        let alertController = UIAlertController(title: "Exit", message: "Do you really want to leave?", preferredStyle: .alert)

        let logoutAction = UIAlertAction(title: "Sign out VK account", style: .default) { action in
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

    private func logout() {
        alertOfExit()
    }
}

extension GroupsFlowPresenter: GroupsFlowViewOutput {

    func fetchData() {
        self.fetchDataFromNetwork()
    }
    
    func dataUpdates() {
        DispatchQueue.main.async {
        self.updatesFromRealm()
        }
    }
    
    func didSearch(search: String) {
        self.filterGroups(with: search)
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
