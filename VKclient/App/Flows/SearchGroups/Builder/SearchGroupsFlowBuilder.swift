//
//  SearchGroupsFlowBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit

final class SearchGroupsFlowBuilder {
    static func build(updateDelegate: SearchGroupsUpdateDelegate) -> (UIViewController & SearchGroupsFlowViewInput) {
        let presenter = SearchGroupsFlowPresenter()
        let viewController = GroupsSearchTableViewController(presenter: presenter)
        presenter.viewInput = viewController
        presenter.updateDelegate = updateDelegate

        return viewController
    }
}
