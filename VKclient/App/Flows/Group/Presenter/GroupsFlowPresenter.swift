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
}

final class GroupsFlowPresenter {
    private var cancellable = Set<AnyCancellable>()
    private let groupService = GroupsService()
    var groupsfromRealm: Results<GroupsRealm>?
    var groupsNotification: NotificationToken?
    var dictOfGroups: [Character: [GroupsRealm]] = [:]
    var firstLetters = [Character]()
    weak var viewInput: (UIViewController & GroupsFlowViewInput)?
//    private var groupsHolder = [GroupsObjects]() {
//        didSet {
//            self.viewInput?.updateTableView()
//        }
//    }
    
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
        self.viewInput?.updateTableView()
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
    
    private func logout() {
        let loginVC = LoginViewController()
        self.viewInput?.view.window?.rootViewController = loginVC
        self.viewInput?.view.window?.makeKeyAndVisible()
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
}
