//
//  GroupsDetailBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-05.
//  Copyright © 2024–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

final class GroupsDetailModuleBuilder {
    static func build(_ group: GroupsRealm, joinGroupDelegate: JoinGroupDelegate, removeGroupDelegate: RemoveGroupDelegate, type: GroupDetailType?) -> (UIViewController & GroupsDetailInput) {
        let presenter = GroupsDetailPresenter(group: group, type: type)
        let viewController = GroupDetailViewController(presenter: presenter)
        presenter.viewInput = viewController
        presenter.joinGroupDelegate = joinGroupDelegate
        presenter.removeGroupDelegate = removeGroupDelegate

        return viewController
    }

    static func buildForNetworkGroups(_ group: GroupsObjects, joinGroupDelegate: JoinGroupDelegate, removeGroupDelegate: RemoveGroupDelegate, type: GroupDetailType?) -> (UIViewController & GroupsDetailInput) {
        let presenter = GroupsDetailPresenter(networkGroup: group, type: type)
        let viewController = GroupDetailViewController(presenter: presenter)
        presenter.viewInput = viewController
        presenter.joinGroupDelegate = joinGroupDelegate
        presenter.removeGroupDelegate = removeGroupDelegate

        return viewController
    }
}
