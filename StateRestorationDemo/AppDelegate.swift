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

    //MARK: App Launch

    /*
     *  Note that we use `willFinishLaunching`, not `didFinishLaunching`
     */

    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        guard let appWindow = window else {
            fatalError()
        }

        // The window will be restored either way, but assigning an identifier
        // adds extra information to the restoration archive (see below)
        appWindow.restorationIdentifier = "mainWindow"

        let firstViewController = FirstViewController(nibName: nil, bundle: nil)

        let secondRootViewController = SecondViewController(nibName: nil, bundle: nil)
        let secondViewController = UINavigationController(rootViewController: secondRootViewController)

        // We might as well assign this internally (e.g., in the view controller's init),
        // but then we'd need a subclass just for that...
        secondViewController.restorationIdentifier = "NavigationController"

        let tabController = UITabBarController()
        tabController.viewControllers = [firstViewController, secondViewController]
        tabController.restorationIdentifier = "TabController"

        appWindow.rootViewController = tabController
        appWindow.makeKeyAndVisible()
        
        return true
    }

    //MARK: State Restoration Opt-In

    /*
     *  Unless these methods return YES, the application's state is not saved/restored, no
     *  matter what you do elsewhere. It's like a global switch.
     *  
     *  You might want to return `false` conditionally in application(_:shouldRestoreApplicationState:)
     *  after version with updates to the view (controller) hierarchy and other, potentially
     *  breaking changes.
     *
     *  Returning `true` in application(_:shouldSaveApplicationState:) will create a restoration
     *  archive which you can inspect using the `restorationArchiveTool` provided by Apple:
     *  
     *  https://developer.apple.com/downloads/ (Login required; search for "restoration")
     *  
     *  Opting into state restoration will also take a snapshot of your app when entering
     *  background mode.
     *
     *  While this generally switches on restoration, it doesn't do much yet: Individual
     *  controllers, views, and other participating objects must implement basic saving/
     *  restoration mechanisms in order for anything actually being restored. This can be
     *  done in code, or with the help of Storyboards. This demo uses code.
     */

    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

}

