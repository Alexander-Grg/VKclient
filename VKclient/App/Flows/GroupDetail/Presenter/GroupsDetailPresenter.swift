//
//  GroupsDetailPresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-05.
//

import UIKit
import RealmSwift
import SDWebImage
import Combine
import KeychainAccess

protocol GroupsDetailInput: AnyObject {
    var groupsDetailView: GroupDetailView { get set }
}

protocol GroupsDetailOutput: AnyObject {
    var isMember: Bool { get }
    func viewDidLoad()
    func joinGroup()
}

final class GroupsDetailPresenter {
    @Injected(\.groupActionsService) var groupActionsService: GroupsActionProtocol
    @Injected(\.groupsService) var groupService: GroupsServiceProtocol
    private var cancellable = Set<AnyCancellable>()
    weak var viewInput: (UIViewController & GroupsDetailInput)?
    var isNetwork = false
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
    var group: GroupsRealm? = nil
    var networkGroup: GroupsObjects? = nil
    
    convenience init(group: GroupsRealm?) {
        self.init()
        self.group = group
    }
    
    convenience init(networkGroup: GroupsObjects?) {
        self.init()
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
    
    private func joinGroupRequest() {
        let id = (isNetwork ? networkGroup?.id : group?.id) ?? 0
        groupActionsService.requestGroupsJoin(id: id)
            .decode(type: GroupsActionsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (error) in
                print("Join group request is failed: \(String(describing: error))")
            }, receiveValue: { (result) in
                if result.response == 1 {
                    print("Join group is successful")
                    self.alertOfJoinStatus()
                    if self.isNetwork {
                        self.networkGroup?.isMember = 1
                    } else {
                        self.group?.isMemberStatus = 1
                    }
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
    
    func joinGroup() {
        self.joinGroupRequest()
    }
}
