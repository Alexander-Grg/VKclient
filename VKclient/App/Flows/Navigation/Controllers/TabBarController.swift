//
//  TabBarController.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 17.05.2022.
//

import Foundation
import UIKit

class TabBarController: UIViewController {

    let tabBar = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
    }

    func createTabBar() {
        let tabOne = NewFriendsTableViewController()
        tabOne.title = "Friends"
        tabOne.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(systemName: "person.3"), selectedImage: UIImage(systemName: "person.3.fill"))

        let tabTwo = CommunitiesTableViewController()
        tabTwo.title = "Groups"
        tabTwo.tabBarItem = UITabBarItem(title: "Groups", image: UIImage(systemName: "rectangle.3.group.bubble.left"), selectedImage: UIImage(systemName: "rectangle.3.group.bubble.left.fill"))

        let tabThree = NewsTableViewController()
        tabThree.title = "News"
        tabThree.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), selectedImage: UIImage(systemName: "newspaper.fill"))

        let controllerArray = [tabOne, tabTwo, tabThree]
        tabBar.viewControllers = controllerArray.map { UINavigationController.init(rootViewController: $0)}

        self.view.addSubview(tabBar.view)
    }
}
