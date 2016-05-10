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
        imageView.image = UIImage(named: cityName)
    }

    // MARK: - State Restoration

    /*
    Provide a new instance on demand, including decoding of its previous state,
    which would else be done in `decodeRestorableStateWithCoder(_)`
    */
    static func viewController(withRestorationIdentifierPath identifierComponents: [AnyObject], coder: NSCoder) -> UIViewController? {
        assert(String(self) == (identifierComponents.last as! String), "unexpected restoration path: \(identifierComponents)")

        guard let restoredName = coder.decodeObject(forKey: encodingKeyCityName) as? String else {
            print("decoding the city name failed")
            // it does not make sense to create an empty controller of this type:
            // abort state restoration at this point
            return nil
        }

        return CityViewController(cityName: restoredName)
    }

    static private let encodingKeyCityName = "encodingKeyCityName"

    override func encodeRestorableState(with coder: NSCoder)  {
        super.encodeRestorableState(with: coder)
        coder.encode(cityName as NSString, forKey: CityViewController.encodingKeyCityName)
    }

    /*
    We have decoded our state in `viewControllerWithRestorationIdentifierPath(_:coder:)`
    already.
    */
    /*override func decodeRestorableStateWithCoder(coder: NSCoder)  {
        super.decodeRestorableStateWithCoder(coder)
    }*/
}
