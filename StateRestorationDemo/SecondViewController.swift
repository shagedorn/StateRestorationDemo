//
//  SecondViewController.swift
//  StateRestorationDemo
//
//  Created by Sebastian Hagedorn on 05/07/14.
//  Copyright (c) 2014 Sebastian Hagedorn. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
                            
    @IBOutlet var imageView: UIImageView
    @IBOutlet var citySelectionControl: UISegmentedControl

    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tabBarItem = UITabBarItem(title: "Second", image: UIImage(named: "second"), tag: 0)
    }

    @IBAction func chooseCity(sender: AnyObject) {
        let cityController = CityViewController()
        navigationController.pushViewController(cityController, animated: true)
    }

}

