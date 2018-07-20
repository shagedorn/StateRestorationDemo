//
//  SecondViewController.swift
//  StateRestorationDemo
//
//  Created by Sebastian Hagedorn on 05/07/14.
//  Copyright (c) 2014 Sebastian Hagedorn. All rights reserved.
//

import UIKit

final class SecondViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var citySelectionControl: UISegmentedControl?

    private let cities = ["Dresden", "Cologne"]

    // MARK: - Initialization

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        tabBarItem = UITabBarItem(title: "Second", image: #imageLiteral(resourceName: "second"), tag: 0)

        // For a discussion, see `FirstViewController.swift`
        restorationIdentifier = String(describing: type(of: self))
    }

    // MARK: - Lifecycle and actions

    override func viewDidLoad() {
        super.viewDidLoad()
        citySelectionControl?.setTitle(cities.first, forSegmentAt: 0)
        citySelectionControl?.setTitle(cities.last, forSegmentAt: 1)

        updateImage()
    }

    private func updateImage() {
        guard let selectionControl = citySelectionControl else {
            return
        }

        let selectedIndex = (selectionControl.selectedSegmentIndex == UISegmentedControl.noSegment) ? 0 : selectionControl.selectedSegmentIndex

        guard cities.indices ~= selectedIndex else {
            assert(false, "selected index '\(selectedIndex)' is out of bounds.")
            return
        }

        let selectedCityImage = UIImage(named: cities[selectedIndex])
        imageView?.image = selectedCityImage
    }

    @IBAction private func selectionChanged(from sender: UISegmentedControl) {
        updateImage()
    }

    @IBAction private func chooseCity(from sender: UIButton) {
        guard let selectedIndex = citySelectionControl?.selectedSegmentIndex else {
            assertionFailure("citySelectionControl not loaded")
            return
        }

        let cityController = CityViewController(cityName: cities[selectedIndex])
        navigationController?.pushViewController(cityController, animated: true)
    }

    // MARK: - State Restoration

    private static let encodingKeySegmentIndex = "encodingKeySegmentIndex"

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        guard let selectionControl = citySelectionControl, isViewLoaded else {
            return
        }

        coder.encode(selectionControl.selectedSegmentIndex, forKey: SecondViewController.encodingKeySegmentIndex)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        assert(isViewLoaded, "We assume the controller is never restored without loading its view first.")
        citySelectionControl?.selectedSegmentIndex = coder.decodeInteger(forKey: SecondViewController.encodingKeySegmentIndex)
        updateImage()
    }

}
