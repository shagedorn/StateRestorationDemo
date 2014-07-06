//
//  AppDelegate.swift
//  StateRestorationDemo
//
//  Created by Sebastian Hagedorn on 05/07/14.
//  Copyright (c) 2014 Sebastian Hagedorn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        // First Screen
        let firstViewController = FirstViewController()

        // Second Screen
        let secondRootViewController = SecondViewController()
        let secondViewController = UINavigationController(rootViewController: secondRootViewController)

        let tabController = UITabBarController()
        tabController.viewControllers = [firstViewController, secondViewController]

        window!.rootViewController = tabController
        window!.makeKeyAndVisible()

        return true
    }

    func application(application: UIApplication!, shouldSaveApplicationState coder: NSCoder!) -> Bool {
        return true
    }

    func application(application: UIApplication!, shouldRestoreApplicationState coder: NSCoder!) -> Bool {
        return true
    }

}

