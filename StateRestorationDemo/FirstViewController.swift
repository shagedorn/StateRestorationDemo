//
//  FirstViewController.swift
//  StateRestorationDemo
//
//  Created by Sebastian Hagedorn on 05/07/14.
//  Copyright (c) 2014 Sebastian Hagedorn. All rights reserved.
//

import UIKit

@objc(FirstViewController) class FirstViewController: UIViewController {

    //MARK: Outlets

    @IBOutlet weak var slider: UISlider!

    //MARK: Initialization

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    final func commonInit() {
        tabBarItem = UITabBarItem(title: "First", image: UIImage(named: "first"), tag: 0)
        restorationIdentifier = String.fromCString(object_getClassName(self))
    }

    //MARK: State Restoring

    override func encodeRestorableStateWithCoder(coder: NSCoder)  {
        super.encodeRestorableStateWithCoder(coder)
        coder.encodeFloat(slider.value, forKey: "encodingKeySliderValue")
    }

    override func decodeRestorableStateWithCoder(coder: NSCoder)  {
        super.decodeRestorableStateWithCoder(coder)
        slider.value = coder.decodeFloatForKey("encodingKeySliderValue")
    }

    override func applicationFinishedRestoringState() {
        print("finished restoring")
    }
}

