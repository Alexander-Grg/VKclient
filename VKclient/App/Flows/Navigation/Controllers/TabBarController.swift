//
//  TabBarController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 17.05.2022.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
    }

    func createTabBar() {
        let tabOne = FriendsFlowModuleBuilder.build()
        tabOne.title = "Friends"
        tabOne.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(systemName: "person.3"), selectedImage: UIImage(systemName: "person.3.fill"))

        let tabTwo = GroupsFlowModuleBuilder.build()
        tabTwo.title = "Groups"
        tabTwo.tabBarItem = UITabBarItem(title: "Groups", image: UIImage(systemName: "rectangle.3.group.bubble.left"), selectedImage: UIImage(systemName: "rectangle.3.group.bubble.left.fill"))

        let tabThree = FeedFlowBuilder.buildNewsFeed()
        tabThree.title = "News"
        tabThree.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), selectedImage: UIImage(systemName: "newspaper.fill"))

        let controllerArray: [UIViewController] = [tabOne, tabTwo, tabThree]
        self.viewControllers = controllerArray.map { UINavigationController.init(rootViewController: $0)}
    }
}
