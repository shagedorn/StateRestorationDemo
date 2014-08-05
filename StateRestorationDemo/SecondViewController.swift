//
//  SecondViewController.swift
//  StateRestorationDemo
//
//  Created by Sebastian Hagedorn on 05/07/14.
//  Copyright (c) 2014 Sebastian Hagedorn. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIStateRestoring {
                            
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var citySelectionControl: UISegmentedControl!

    var cities: Array<String> = ["Dresden", "Cologne"]

    override init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Second", image: UIImage(named: "second"), tag: 0)
        restorationIdentifier = String.fromCString(object_getClassName(self))
    }

    required init(coder aDecoder: NSCoder!) {
        fatalError("NSCoding not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        citySelectionControl.setTitle(cities[0], forSegmentAtIndex: 0)
        citySelectionControl.setTitle(cities[1], forSegmentAtIndex: 1)

        var selectedIndex = citySelectionControl.selectedSegmentIndex
        if selectedIndex == UISegmentedControlNoSegment {
            selectedIndex = 0
        }
        let selectedCityImage = UIImage(named: cities[selectedIndex])
        imageView.image = selectedCityImage
    }

    @IBAction func selectionChanged(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        var selectedCityImage = UIImage(named: cities[selectedIndex])
        imageView.image = selectedCityImage
    }

    @IBAction func chooseCity(sender: AnyObject) {
        let selectedIndex = citySelectionControl.selectedSegmentIndex
        let cityController = CityViewController(cityName:cities[selectedIndex])
        navigationController.pushViewController(cityController, animated: true)
    }

    override func encodeRestorableStateWithCoder(coder: NSCoder!)  {
        super.encodeRestorableStateWithCoder(coder)
        coder.encodeInteger(citySelectionControl.selectedSegmentIndex, forKey: "encodingKeySegmentIndex")
    }

    override func decodeRestorableStateWithCoder(coder: NSCoder!)  {
        super.decodeRestorableStateWithCoder(coder)
        citySelectionControl.selectedSegmentIndex = coder.decodeIntegerForKey("encodingKeySegmentIndex")
        selectionChanged(citySelectionControl)
    }

}

