//
//  CityViewController.swift
//  StateRestorationDemo
//
//  Created by Sebastian Hagedorn on 05/07/14.
//  Copyright (c) 2014 Sebastian Hagedorn. All rights reserved.
//

import UIKit

class CityViewController: UIViewController, UIViewControllerRestoration, UIStateRestoring {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var cityName: String

    init(cityName: String) {
        self.cityName = cityName
        super.init(nibName: nil, bundle: nil)
        restorationIdentifier = String.fromCString(object_getClassName(self))
        restorationClass = object_getClass(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if cityName.utf16Count > 0 {
            nameLabel.text = cityName
            imageView.image = UIImage(named:cityName)
        }
    }

    class func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject]!, coder: NSCoder!) -> UIViewController! {
        return CityViewController(cityName: "")
    }

    override func encodeRestorableStateWithCoder(coder: NSCoder!)  {
        super.encodeRestorableStateWithCoder(coder)
        coder.encodeObject(cityName, forKey: "encodingKeyName")
    }

    override func decodeRestorableStateWithCoder(coder: NSCoder!)  {
        super.decodeRestorableStateWithCoder(coder)
        cityName = coder.decodeObjectForKey("encodingKeyName") as String
        nameLabel.text = cityName
        imageView.image = UIImage(named:cityName)
    }
}
