//
//  SearchGroupsFlowBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/3/22.
//

import UIKit

final class SearchGroupsFlowBuilder {
    static func build() -> (UIViewController & SearchGroupsFlowViewInput) {
        let presenter = SearchGroupsFlowPresenter()
        let viewController = GroupsSearchTableViewController(presenter: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}
