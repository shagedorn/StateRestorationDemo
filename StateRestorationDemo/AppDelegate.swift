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

    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.restorationIdentifier = "mainWindow"

        // First Screen
        let firstViewController = FirstViewController(nibName: nil, bundle: nil)

        // Second Screen
        let secondRootViewController = SecondViewController(nibName: nil, bundle: nil)
        let secondViewController = UINavigationController(rootViewController: secondRootViewController)
        secondViewController.restorationIdentifier = "NavigationController"

        let tabController = UITabBarController()
        tabController.viewControllers = [firstViewController, secondViewController]
        tabController.restorationIdentifier = "TabController"

        window!.rootViewController = tabController
        window!.makeKeyAndVisible()
        
        return true
    }

    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

}

