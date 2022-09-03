//
//  FriendsFlowModuleBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/2/22.
//

import UIKit

final class FriendsFlowModuleBuilder {
    static func build() -> (UIViewController & FriendsFlowViewInput) {
        let presenter = FriendsFlowPresenter()
        let viewController = NewFriendsTableViewController(presenter: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}
