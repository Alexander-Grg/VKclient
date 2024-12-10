//
//  GroupsDetailBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-05.
//

import UIKit

final class GroupsDetailModuleBuilder {
    static func build(_ group: GroupsRealm, joinGroupDelegate: JoinGroupDelegate, removeGroupDelegate: RemoveGroupDelegate ) -> (UIViewController & GroupsDetailInput) {
        let presenter = GroupsDetailPresenter(group: group)
        let viewController = GroupDetailViewController(presenter: presenter)
        presenter.viewInput = viewController
        presenter.joinGroupDelegate = joinGroupDelegate
        presenter.removeGroupDelegate = removeGroupDelegate

        return viewController
    }

    static func buildForNetworkGroups(_ group: GroupsObjects, joinGroupDelegate: JoinGroupDelegate, removeGroupDelegate: RemoveGroupDelegate) -> (UIViewController & GroupsDetailInput) {
        let presenter = GroupsDetailPresenter(networkGroup: group)
        let viewController = GroupDetailViewController(presenter: presenter)
        presenter.viewInput = viewController
        presenter.joinGroupDelegate = joinGroupDelegate
        presenter.removeGroupDelegate = removeGroupDelegate

        return viewController
    }
}
