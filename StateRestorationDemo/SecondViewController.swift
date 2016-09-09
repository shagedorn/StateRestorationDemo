//
//  SecondViewController.swift
//  StateRestorationDemo
//
//  Created by Sebastian Hagedorn on 05/07/14.
//  Copyright (c) 2014 Sebastian Hagedorn. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
                            
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var citySelectionControl: UISegmentedControl!

    private let cities = ["Dresden", "Cologne"]

    // MARK - Initialization

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }

    final private func commonInit() {
        tabBarItem = UITabBarItem(title: "Second", image: UIImage(named: "second"), tag: 0)
        
        // For a discussion, see `FirstViewController.swift`
        restorationIdentifier = String(describing: type(of: self))
    }

    // MARK: - Lifecycle and actions

    override func viewDidLoad() {
        super.viewDidLoad()
        citySelectionControl.setTitle(cities[0], forSegmentAt: 0)
        citySelectionControl.setTitle(cities[1], forSegmentAt: 1)

        updateImage()
    }

    private func updateImage() {
        let selectedIndex = (citySelectionControl.selectedSegmentIndex == UISegmentedControlNoSegment) ? 0 : citySelectionControl.selectedSegmentIndex
        guard cities.indices ~= selectedIndex else {
            assert(false, "selected index '\(selectedIndex)' is out of bounds.")
            return
        }

        let selectedCityImage = UIImage(named: cities[selectedIndex])
        imageView.image = selectedCityImage
    }

    @IBAction private func selectionChanged(_: UISegmentedControl) {
        updateImage()
    }

    @IBAction private func chooseCity(_: UIButton) {
        let selectedIndex = citySelectionControl.selectedSegmentIndex
        let cityController = CityViewController(cityName:cities[selectedIndex])
        navigationController?.pushViewController(cityController, animated: true)
    }

    // MARK: - State Restoration

    private let encodingKeySegmentIndex = "encodingKeySegmentIndex"

    override func encodeRestorableState(with coder: NSCoder)  {
        super.encodeRestorableState(with: coder)
        guard isViewLoaded else {
            // For a discussion, see `FirstViewController.swift`
            return
        }

        coder.encode(citySelectionControl.selectedSegmentIndex, forKey: encodingKeySegmentIndex)
    }

    override func decodeRestorableState(with coder: NSCoder)  {
        super.decodeRestorableState(with: coder)
        assert(isViewLoaded, "We assume the controller is never restored without loading its view first.")
        citySelectionControl.selectedSegmentIndex = coder.decodeInteger(forKey: encodingKeySegmentIndex)
        updateImage()
    }

}

