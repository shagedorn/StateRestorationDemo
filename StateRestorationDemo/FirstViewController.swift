//
//  FirstViewController.swift
//  StateRestorationDemo
//
//  Created by Sebastian Hagedorn on 05/07/14.
//  Copyright (c) 2014 Sebastian Hagedorn. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
                            
    @IBOutlet var slider: UISlider
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "First", image: UIImage(named: "first"), tag: 0)
        restorationIdentifier = NSString(CString: object_getClassName(self))
    }
}

