//
//  AppDelegate.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/13/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchCoordinator: LaunchFlowCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Firebase Configuring
        FirebaseClient.configure()
//        Database.database().isPersistenceEnabled = true
        startApplicationFlow()
        return true
    }
    // MARK: - Starting Application Flow
    func startApplicationFlow() {
        if let navigationController = window?.rootViewController as? UINavigationController {
            launchCoordinator = LaunchFlowCoordinator(rootController: navigationController, context: LaunchFlowContext())
            launchCoordinator.start()
        }
    }
}

