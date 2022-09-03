//
//  FriendsFlowPresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 8/18/22.
//

import Foundation
import Combine
import RealmSwift
import UIKit

//Refers to View
protocol FriendsFlowViewInput: AnyObject {
    func updateTableView()
    func buttonDidPress()
}

//Refers to Presentor methods
protocol FriendsFlowViewOutput: AnyObject {
    var dictOfUsers: [Character: [UserRealm]] { get }
    var firstLetters: [Character] { get }
    func fetchData()
    func dataUpdates()
    func logout()
    func didSearch(search: String)
    func goNextScreen(index: IndexPath)
}

final class FriendsFlowPresenter {
    private var cancellable = Set<AnyCancellable>()
    private let userService = UserService()
    private var friendsFromRealm: Results<UserRealm>?
    private var notificationFriends: NotificationToken?
    internal var dictOfUsers: [Character: [UserRealm]] = [:]
    internal var firstLetters = [Character]()
    
    weak var viewInput: (UIViewController & FriendsFlowViewInput)?
    
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
         self.viewInput?.updateTableView()
        }
    
     private func fetchDataFromNetwork() {
        userService.requestUsers()
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.savingDataToRealm(value.response.items)
                self.loadDataFromRealm()
                self.usersFilteredFromRealm(with: self.friendsFromRealm)
            }
            )
            .store(in: &cancellable)
   }
   
     private func savingDataToRealm(_ data: [UserObject]) {
         do {
             let dataRealm = data.map {UserRealm(user: $0)}
             try RealmService.save(items: dataRealm)
         } catch {
             print("Saving to Realm failed")
         }
    }
    
    private func loadDataFromRealm() {
        do {
            self.friendsFromRealm = try RealmService.get(type: UserRealm.self)
        } catch {
            print("Download from Realm failed")
        }
    }

     private func updatesFromRealm() {
         self.notificationFriends = friendsFromRealm?.observe { [weak self] changes in
           guard let self = self else { return }
           switch changes {
           case .initial:
               break
           case .update:
               self.viewInput?.updateTableView()
               self.loadDataFromRealm()
               self.usersFilteredFromRealm(with: self.friendsFromRealm)
           case let .error(error):
               print(error)
           }
       }
   }
    
    private  func filterFriends(with text: String) {
        guard !text.isEmpty else {
            usersFilteredFromRealm(with: self.friendsFromRealm)
            return
        }
        usersFilteredFromRealm(with: self.friendsFromRealm?.filter("firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@", text, text))
        self.viewInput?.updateTableView()
    }
    
      private func openFriendsPhotos(indexPath: IndexPath) {
        let firstLetter = self.firstLetters[indexPath.section]
        if let users = self.dictOfUsers[firstLetter] {
            let userID = users[indexPath.row].id
            Session.instance.friendID = userID
            let viewController = PhotoViewController()
            self.viewInput?.navigationController?.pushViewController(viewController.self, animated: true)
        }
    }
    
    internal func logout() {
        let loginVC = LoginViewController()
        viewInput?.view.window?.rootViewController = loginVC
        viewInput?.view.window?.makeKeyAndVisible()
    }
}

extension FriendsFlowPresenter: FriendsFlowViewOutput {
    
    func fetchData() {
        self.fetchDataFromNetwork()
    }
    
    func dataUpdates() {
        self.updatesFromRealm()
    }
    
    func didSearch(search: String) {
        self.filterFriends(with: search)
    }
    
    func goNextScreen(index: IndexPath) {
        self.openFriendsPhotos(indexPath: index)
    }
}
