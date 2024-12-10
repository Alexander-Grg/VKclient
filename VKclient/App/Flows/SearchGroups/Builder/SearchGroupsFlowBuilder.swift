//
//  SearchGroupsFlowBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
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
