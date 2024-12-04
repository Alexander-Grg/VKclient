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
import KeychainAccess

protocol FriendsFlowViewInput: AnyObject {
    func updateTableView()
}

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
    @Injected(\.userService) var userService
    private var cancellable = Set<AnyCancellable>()
    private var friendsFromRealm: Results<UserRealm>?
    private var notificationFriends: NotificationToken?
    internal var dictOfUsers: [Character: [UserRealm]] = [:]
    internal var firstLetters = [Character]()
    
    weak var viewInput: (UIViewController & FriendsFlowViewInput)?
    
    // MARK: - Function for tableView sections
    private func usersFilteredFromRealm(with friends: Results<UserRealm>?) {
        guard let filteredFriends = friends else { return }
        dictOfUsers.removeAll()
         firstLetters.removeAll()

        filteredFriends.forEach { friend in
             guard let dictKey = friend.lastName.first else { return }

             var groupsForLetter = dictOfUsers[dictKey, default: []]
             groupsForLetter.append(friend)
             dictOfUsers[dictKey] = groupsForLetter

             if !firstLetters.contains(dictKey) {
                 firstLetters.append(dictKey)
             }
         }

         firstLetters.sort()
         viewInput?.updateTableView()
    }

    private func fetchDataFromNetwork() {
        userService.requestUsers()
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("THERE IS NO DATA: \(error.localizedDescription)")
                    self.alertOfNoData()
                case .finished:
                    print("The data is received")
                }
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
            do {
               try Keychain().set("\(userID)", key: "userID")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            let viewController = PhotosFlowBuilder.build()
            self.viewInput?.navigationController?.pushViewController(viewController.self, animated: true)
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

    private func alertOfNoData() {
        let alertController = UIAlertController(title: "Error", message: "The App could not get the data. Please sign in again.", preferredStyle: .alert)

        let logoutAction = UIAlertAction(title: "Ok", style: .default) { action in

                    let VKlogin = VKLoginController()
            self.viewInput?.view.window?.rootViewController = VKlogin
            self.viewInput?.view.window?.makeKeyAndVisible()
        }
        alertController.addAction(logoutAction)

        viewInput?.present(alertController, animated: true)
    }

    internal func logout() {
        alertOfExit()
    }
}

extension FriendsFlowPresenter: FriendsFlowViewOutput {
    
    func fetchData() {
        self.fetchDataFromNetwork()
    }
    
    func dataUpdates() {
        DispatchQueue.main.async {
            self.updatesFromRealm()
        }
    }
    
    func didSearch(search: String) {
        self.filterFriends(with: search)
    }
    
    func goNextScreen(index: IndexPath) {
        self.openFriendsPhotos(indexPath: index)
    }
}
