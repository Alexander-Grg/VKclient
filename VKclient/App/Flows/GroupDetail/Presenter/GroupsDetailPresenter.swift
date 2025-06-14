//
//  GroupsDetailPresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-05.
//  Copyright © 2024–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage
import Combine
import KeychainAccess
import Realm


protocol RemoveGroupDelegate: AnyObject {
    func removeGroup(_ id: Int?)
}

protocol JoinGroupDelegate: AnyObject {
    func joinGroupDelegation(_ isJoined: Bool)
}

protocol GroupsDetailInput: AnyObject {
    var groupsDetailView: GroupDetailView { get set }
}

protocol GroupsDetailOutput: AnyObject {
    var isMember: Bool { get }
    var type: GroupDetailType? { get }
    var group: GroupsRealm? { get }
    func viewDidLoad()
    func joinGroup(completion: @escaping () -> Void)
    func leaveGroup(completion: @escaping () -> Void)
}

final class GroupsDetailPresenter {
    @Injected(\.groupActionsService) var groupActionsService: GroupsActionProtocol
    @Injected(\.groupsService) var groupService: GroupsServiceProtocol
    weak var joinGroupDelegate: JoinGroupDelegate?
    weak var removeGroupDelegate: RemoveGroupDelegate?

    private var cancellable = Set<AnyCancellable>()
    weak var viewInput: (UIViewController & GroupsDetailInput)?
    var isNetwork = false
    var type: GroupDetailType?
    var isMember: Bool {
        let status = (isNetwork ? networkGroup?.isMember : group?.isMemberStatus) ?? 0
        switch status {
        case 1:
            return true
        case 0:
            return false
        default:
            return false
        }
    }

    var isGroupJoined = false
    var realmGroups: Results<GroupsRealm>? = nil
    var networkGroup: GroupsObjects? = nil
    var group: GroupsRealm? = nil

    init (type: GroupDetailType?) {
        self.type = type
    }

    convenience init(group: GroupsRealm?, type: GroupDetailType?) {
        self.init(type: type)
        self.group = group
    }

    convenience init(networkGroup: GroupsObjects?, type: GroupDetailType?) {
        self.init(type: type)
        self.isNetwork = true
        self.networkGroup = networkGroup
    }

    private func configureView() {
        if isNetwork {
            guard let group = networkGroup,
                  let networkImageURL = URL(string: group.photo200)
            else { return }
            viewInput?.groupsDetailView.groupNameLabel.text = group.name
            viewInput?.groupsDetailView.groupImage.sd_setImage(with: networkImageURL)

            viewInput?.groupsDetailView.groupStatusLabel.text = group.groupStatusString
            if !((group.isDeactivated?.isEmpty) != nil) {
                viewInput?.groupsDetailView.isDeletedLabel.text = group.isDeactivated
            }
            viewInput?.groupsDetailView.isMemberLabel.text = group.isMemberString
            viewInput?.groupsDetailView.groupImage.sd_setImage(with: networkImageURL)
        } else {
            guard let group = group,
                  let imageURL = URL(string: group.photo200)
            else { return }
            viewInput?.groupsDetailView.groupNameLabel.text = group.name
            viewInput?.groupsDetailView.groupImage.sd_setImage(with: imageURL)
            viewInput?.groupsDetailView.groupStatusLabel.text = group.groupStatus
            if !group.isDeleted.isEmpty {
                viewInput?.groupsDetailView.isDeletedLabel.text = group.isDeleted
            }
            viewInput?.groupsDetailView.isMemberLabel.text = group.isMemberString
        }
    }

    private func leaveGroupRequest(completion: @escaping () -> Void) {
        let id = (isNetwork ? networkGroup?.id : group?.id) ?? 0
        groupActionsService.requestGroupsLeave(id: id)
            .decode(type: GroupsActionsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionResult in
                switch completionResult {
                case .finished:
                    print("The process of leaving group is finished")
                case .failure(let error):
                    print("The leave group process failed: \(String(describing: error))")
                }
            }, receiveValue: { result in
                if result.response == 1 {
                    if self.isNetwork {
                        self.networkGroup?.isMember = 0
                        self.removeGroupDelegate?.removeGroup(self.networkGroup?.id)
                    } else {
                        self.removeGroupDelegate?.removeGroup(self.group?.id)
                    }
                    self.viewInput?.navigationController?.popViewController(animated: true)
                    self.group = nil
                    completion()
                }
            })
            .store(in: &cancellable)
    }

    private func joinGroupRequest(completion: @escaping () -> Void) {
        let id = (isNetwork ? networkGroup?.id : group?.id) ?? 0
        groupActionsService.requestGroupsJoin(id: id)
            .decode(type: GroupsActionsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print("Join group request is failed: \(String(describing: error))")
            }, receiveValue: { result in
                if result.response == 1 {
                    print("Join group is successful")
                    self.alertOfJoinStatus()
                    self.joinGroupDelegate?.joinGroupDelegation(true)
                    if self.isNetwork {
                        self.networkGroup?.isMember = 1
                    } else {
                        self.group?.isMemberStatus = 1
                    }
                    completion()
                }
            })
            .store(in: &cancellable)
    }

    private func alertOfJoinStatus() {
        let alertController = UIAlertController(title: "Success", message: "You've succesfully joined the group", preferredStyle: .alert)
        let updateDataAction = UIAlertAction(title: "Ok", style: .default) { action in
            self.viewInput?.groupsDetailView.setupJoinLeaveButton(isJoined: self.isMember)
            self.configureView()
        }
        alertController.addAction(updateDataAction)
        
        viewInput?.present(alertController, animated: true)
    }
}

extension GroupsDetailPresenter: GroupsDetailOutput {
    
    func viewDidLoad() {
        self.configureView()
    }
    
    func joinGroup(completion: @escaping () -> Void) {
        joinGroupRequest(completion: completion)
    }

    func leaveGroup(completion: @escaping () -> Void) {
        leaveGroupRequest(completion: completion)
    }
}

extension GroupsDetailPresenter: JoinGroupDelegate {
    func joinGroupDelegation(_ isJoined: Bool) {
        if isJoined {
            joinGroupDelegate?.joinGroupDelegation(true)
          }
    }
}
