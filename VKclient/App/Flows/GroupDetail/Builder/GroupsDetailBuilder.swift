//
//  GroupsDetailBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 2024-02-05.
//

import UIKit

final class GroupsDetailModuleBuilder {
    static func build(_ group: GroupsRealm) -> (UIViewController & GroupsDetailInput) {
        let presenter = GroupsDetailPresenter(group: group)
        let viewController = GroupDetailViewController(presenter: presenter)
        presenter.viewInput = viewController

        return viewController
    }
}
