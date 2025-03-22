//
//  GroupsFlowBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
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

