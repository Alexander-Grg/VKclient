//
//  AppStartManager.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 17.05.2022.
//

import UIKit

final class AppStartManager {
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let rootVC = VKLoginController()
        
        let navVC = self.configuredNavigationController
        navVC.viewControllers = [rootVC]
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
    
    private lazy var configuredNavigationController: UINavigationController = {
        let navVC = UINavigationController()
        navVC.isNavigationBarHidden = true
        
        return navVC
    }()
}
