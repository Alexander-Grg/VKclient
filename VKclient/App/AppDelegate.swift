//
//  AppDelegate.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 17.05.2022.
//  Copyright © 2022–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
import KeychainAccess

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let keychain = Keychain()
    var window: UIWindow?
    var appStartManager: AppStartManager?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.appStartManager = AppStartManager(window: self.window)
        self.appStartManager?.start()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        do {
            try keychain.remove("token")
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        do {
            try keychain.remove("token")
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
    }
}
