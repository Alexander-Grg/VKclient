//
//  GroupsFlowBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//

import UIKit

final class GroupsFlowModuleBuilder {
    static func build() -> (UIViewController & GroupsFlowViewInput) {
        let presenter = GroupsFlowPresenter()
        let viewController = CommunitiesTableViewController(presenter: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}

