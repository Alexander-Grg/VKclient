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
    var group: GroupsRealm? = nil

    convenience init(group: GroupsRealm?) {
        self.init()
        self.group = group
    }

    private func configureView() {
        guard
              let group = group,
              let imageURL = URL(string: group.photo200)
        else { return }
        
        viewInput?.groupsDetailView.groupNameLabel.text = group.name
        viewInput?.groupsDetailView.groupImage.sd_setImage(with: imageURL)
        viewInput?.groupsDetailView.groupStatusLabel.text = group.groupStatusString
        if !group.isDeleted.isEmpty {
            viewInput?.groupsDetailView.isDeletedLabel.text = group.isDeleted
        }
        viewInput?.groupsDetailView.isMemberLabel.text = group.isMemberString

    }


}

extension GroupsDetailPresenter: GroupsDetailOutput {
    func viewDidLoad() {
        self.configureView()
        viewInput?.reloadInputViews()
    }
}
