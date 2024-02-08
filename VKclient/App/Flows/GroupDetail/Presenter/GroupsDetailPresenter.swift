//
//  GroupsDetailPresenter.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-05.
//

import UIKit
import RealmSwift
import SDWebImage

protocol GroupsDetailInput: AnyObject {
    var groupsDetailView: GroupDetailView { get set }
}

protocol GroupsDetailOutput: AnyObject {
    func viewDidLoad()
}

final class GroupsDetailPresenter {
    
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
}

extension GroupsDetailPresenter: GroupsDetailOutput {
    func viewDidLoad() {
        self.configureView()
        viewInput?.reloadInputViews()
    }
}
