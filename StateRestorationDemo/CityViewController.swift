//
//  CityViewController.swift
//  StateRestorationDemo
//
//  Created by Sebastian Hagedorn on 05/07/14.
//  Copyright (c) 2014 Sebastian Hagedorn. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet var imageView: UIImageView
    @IBOutlet var nameLabel: UILabel

    var cityName: String

    init(cityName: String) {
        self.cityName = cityName
        super.init(nibName: nil, bundle: nil)
        restorationIdentifier = NSString(CString: object_getClassName(self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = cityName
        imageView.image = UIImage(named:cityName)
    }
}
