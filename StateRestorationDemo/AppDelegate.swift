//
//  AppDelegate.swift
//  StateRestorationDemo
//
//  Created by Sebastian Hagedorn on 05/07/14.
//  Copyright (c) 2014 Sebastian Hagedorn. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - App Launch

    /*
     *  Note that we use `willFinishLaunching`, not `didFinishLaunching`
     */
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let appWindow = window else {
            fatalError("failed to create window")
        }

        /*
         *  The window will be restored either way, but assigning an identifier
         *  adds extra information (e.g., last-used size classes) to the
         *  restoration archive (see below)
         */
        appWindow.restorationIdentifier = "MainWindow"

        let firstViewController = FirstViewController()

        let secondRootViewController = SecondViewController()
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

    // MARK: - State Restoration Opt-In

    /*
     *  Unless these methods return YES, the application's state is not saved/restored, no
     *  matter what you do elsewhere. Consider it a global switch.
     *
     *  You might want to return `false` conditionally in application(_:shouldRestoreApplicationState:)
     *  after app updates that include changes to the view (controller) hierarchy and other, potentially
     *  restoration-breaking changes.
     *
     *  Returning `true` in application(_:shouldSaveApplicationState:) will create a restoration
     *  archive ("data.data") which you can inspect using the `restorationArchiveTool` provided by Apple:
     *
     *  https://developer.apple.com/downloads/ (Login required; search for "restoration")
     *
     *  Opting into state restoration will also take a snapshot of your app when entering
     *  background mode.
     *
     *  While this generally switches on restoration, it doesn't do much yet: Individual
     *  controllers, views, and other participating objects must implement basic saving/
     *  restoration mechanisms in order for anything to actually restore. This can be
     *  done in code, or with the help of Storyboards. This demo focusses on code.
     *
     *  General debugging tips:
     *
     *  To get the app to restore in the simulator, follow these steps:
     *
     *  - send the app to the background (home button / cmd + h)
     *  - quit the app in Xcode
     *  - relaunch the app
     *
     *  Do not force-quit the app in the app switcher - this deletes the restoration archive.
     *  Do not kill the app while still in the foreground, as the restoration archive is created
     *  when the app goes into the background. To debug state restoration on device, read the
     *  documentation provided with the `restorationArchiveTool` mentioned above.
     */
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        // archive files will end up in this directory – only printing it for debugging
        // purposes so you can quickly `cd` there
        let libDir = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("Saved Application State")
        print("Restoration files: \(String(describing: libDir))")

        return true
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        true
    }

}
