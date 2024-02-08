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

protocol GroupsDetailInput: AnyObject {
    var groupsDetailView: GroupDetailView { get set }
}

protocol GroupsDetailOutput: AnyObject {
    func viewDidLoad()
    func joinGroup()
}

final class GroupsDetailPresenter {
    @Injected (\.groupActionsService) var groupService: GroupsActionProtocol
    private var cancellable = Set<AnyCancellable>()
    weak var viewInput: (UIViewController & GroupsDetailInput)?
    var isNetwork = false
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
            viewInput?.groupsDetailView.isMemberLabel.text = group.isMember
        }
    }

    internal func joinGroupRequest() {
        var id = (isNetwork ? networkGroup?.id : group?.id) ?? 0
        groupService.requestGroupsJoin(id: id)
            .decode(type: GroupsActionsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (error) in
                print("Join group request is failed: \(String(describing: error))")
            }, receiveValue: { (result) in
                if result.response == 1 {
                    print("Join group is succesful")
                }
            })
            .store(in: &cancellable)
    }

//    private func fetchDataFromNetwork() {
//        groupService.requestGroups()
//            .decode(type: GroupsResponse.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { error in
//                print(error)
//            }, receiveValue: { [weak self] value in
//                guard let self = self else { return }
//                self.savingDataToRealm(value.response.items)
//                self.loadDataFromRealm()
//                self.groupsFilteredFromRealm(with: self.groupsfromRealm)
//            }
//            )
//            .store(in: &cancellable)
//    }

    private func leaveGroup(groupID: Int) {
        groupService.requestGroupsLeave(id: groupID)
    }
}

extension GroupsDetailPresenter: GroupsDetailOutput {
    func viewDidLoad() {
        self.configureView()
        viewInput?.reloadInputViews()
    }

    func joinGroup() {
        self.joinGroupRequest()
        viewInput?.reloadInputViews()
    }
}
