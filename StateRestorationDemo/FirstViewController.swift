//
//  FirstViewController.swift
//  StateRestorationDemo
//
//  Created by Sebastian Hagedorn on 05/07/14.
//  Copyright (c) 2014 Sebastian Hagedorn. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIStateRestoring {
                            
    @IBOutlet var slider: UISlider
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "First", image: UIImage(named: "first"), tag: 0)
        restorationIdentifier = String.fromCString(object_getClassName(self))
    }

    override func encodeRestorableStateWithCoder(coder: NSCoder!)  {
        super.encodeRestorableStateWithCoder(coder)
        coder.encodeFloat(slider.value, forKey: "encodingKeySliderValue")
    }

    override func decodeRestorableStateWithCoder(coder: NSCoder!)  {
        super.decodeRestorableStateWithCoder(coder)
        slider.value = coder.decodeFloatForKey("encodingKeySliderValue")
    }
}

