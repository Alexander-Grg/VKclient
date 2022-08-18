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

protocol FriendsFlowViewInput: AnyObject {
    
}

protocol FriendsFlowViewOutput: AnyObject {
    
}

final class FriendsFlowPresenter {
    private var cancellable = Set<AnyCancellable>()
    private let userService = UserService()
    var friendsFromRealm: Results<UserRealm>?
    var notificationFriends: NotificationToken?
    var dictOfUsers: [Character: [UserRealm]] = [:]
    var firstLetters = [Character]()
    var networkValue: [UserObject] = []
    
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
            tableView.reloadData()
        }
    
    func fetchDataFromNetwork() {
        userService.requestUsers()
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { [weak self] value in
                self?.savingDataToRealm(value.response.items)
                self?.updatesFromRealm()
                self?.usersFilteredFromRealm(with: self?.friendsFromRealm)
            }
            )
            .store(in: &cancellable)
   }
   
  private func savingDataToRealm(_ data: [UserObject]) {
        do {
            let dataRealm = data.map {UserRealm(user: $0)}
            try? RealmService.save(items: dataRealm)
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
    
    func openFriendsPhotos(indexPath: IndexPath, navigationController: UINavigationController) {
        let firstLetter = self.firstLetters[indexPath.section]
        if let users = self.dictOfUsers[firstLetter] {
            let userID = users[indexPath.row].id
            Session.instance.friendID = userID
            let viewController = PhotoViewController()
            navigationController.pushViewController(viewController.self, animated: true)
        }
    }

}

extension FriendsFlowPresenter: FriendsFlowViewOutput {
    
}
