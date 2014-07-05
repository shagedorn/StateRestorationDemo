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
        let firstViewController = FirstViewController(nibName: nil, bundle: nil)

        // Second Screen
        let secondRootViewController = SecondViewController(nibName: nil, bundle: nil)
        let secondViewController = UINavigationController(rootViewController: secondRootViewController)

        let tabController = UITabBarController()
        tabController.viewControllers = [firstViewController, secondViewController]

        window!.rootViewController = tabController
        window!.makeKeyAndVisible()

        return true
    }

}

