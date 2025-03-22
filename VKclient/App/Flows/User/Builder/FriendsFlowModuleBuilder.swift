//
//  FriendsFlowModuleBuilder.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 9/2/22.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
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

