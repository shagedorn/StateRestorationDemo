//
//  CityViewController.swift
//  StateRestorationDemo
//
//  Created by Sebastian Hagedorn on 05/07/14.
//  Copyright (c) 2014 Sebastian Hagedorn. All rights reserved.
//

import UIKit

/*
Note the extra protocol: This view controller is not initially created
(before `application(_:willFinishLaunchingWithOptions:)` returns), so
it may have to be created on demand for state restoration.
*/
class CityViewController: UIViewController, UIViewControllerRestoration {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    private var cityName: String

    // MARK: - Initialization

    init(cityName: String) {
        self.cityName = cityName
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true

        // For a discussion, see `FirstViewController.swift`
        restorationIdentifier = String(self.dynamicType)

        /*
        The class specified here must conform to `UIViewControllerRestoration`,
        explained above. If not set, you'd get a second chance to create the
        view controller on demand in the app delegate.
        */
        restorationClass = self.dynamicType
    }

    required init(coder aDecoder: NSCoder) {
        cityName = ""
        assert(false, "init(coder:) not supported. Please use init(cityName:) instead.")
        super.init(coder: aDecoder)!
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

    private func updateView() {
        nameLabel.text = cityName
        guard !cityName.characters.isEmpty else {
            // prevent CUICatalog warnings if image was not found
            return
        }
        imageView.image = UIImage(named: cityName)
    }

    // MARK: - State Restoration

    /*
    Provide a new instance on demand. At this point, we have no further information regarding
    the object's state (e.g., the view controller's `cityName` property state). All we know
    is its former place in the view controller hierarchy, described by `identifierComponents`.
    */
    class func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject], coder: NSCoder) -> UIViewController? {
        assert(String(self) == (identifierComponents.last as! String), "unexpected restoration path: \(identifierComponents)")
        return CityViewController(cityName: "")
    }

    private let encodingKeyCityName = "encodingKeyCityName"

    override func encodeRestorableStateWithCoder(coder: NSCoder)  {
        super.encodeRestorableStateWithCoder(coder)
        coder.encodeObject(cityName, forKey: encodingKeyCityName)
    }

    override func decodeRestorableStateWithCoder(coder: NSCoder)  {
        super.decodeRestorableStateWithCoder(coder)
        assert(isViewLoaded(), "We assume the controller is never restored without loading its view first.")
        guard let restoredName = coder.decodeObjectForKey(encodingKeyCityName) as? String else {
            assert(false, "decoding the city name failed")
            return
        }
        cityName = restoredName
        updateView()
    }
}
