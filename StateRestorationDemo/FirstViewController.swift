//
//  FirstViewController.swift
//  StateRestorationDemo
//
//  Created by Sebastian Hagedorn on 05/07/14.
//  Copyright (c) 2014 Sebastian Hagedorn. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIStateRestoring {
                            
    @IBOutlet weak var slider: UISlider!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "FirstViewController", bundle: nil)
        tabBarItem = UITabBarItem(title: "First", image: UIImage(named: "first"), tag: 0)
        restorationIdentifier = String.fromCString(object_getClassName(self))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override func encodeRestorableStateWithCoder(coder: NSCoder)  {
        super.encodeRestorableStateWithCoder(coder)
        coder.encodeFloat(slider.value, forKey: "encodingKeySliderValue")
    }

    override func decodeRestorableStateWithCoder(coder: NSCoder)  {
        super.decodeRestorableStateWithCoder(coder)
        slider.value = coder.decodeFloatForKey("encodingKeySliderValue")
    }
}

