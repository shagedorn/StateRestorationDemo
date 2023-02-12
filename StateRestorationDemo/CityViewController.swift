import UIKit

final class CityViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var nameLabel: UILabel?

    private let cityName: String

    // MARK: - Initialization

    init(cityName: String) {
        self.cityName = cityName
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true

        // For a discussion, see `FirstViewController.swift`
        restorationIdentifier = String(describing: type(of: self))

        // The class specified here must conform to `UIViewControllerRestoration`,
        // as explained below. If not set, you'd get a second chance to create
        // the view controller on demand in the app delegate (with essentially
        // the same method signature).
        restorationClass = type(of: self)
    }

    required init?(coder aDecoder: NSCoder) {
        cityName = ""
        assertionFailure("init(coder:) not supported. Please use init(cityName:) instead.")
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

    private func updateView() {
        nameLabel?.text = cityName
        imageView?.image = .init(named: cityName)
    }

    // MARK: - State Restoration

    private static let encodingKeyCityName = "encodingKeyCityName"

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        coder.encode(cityName, forKey: Self.encodingKeyCityName)
    }

    // We have decode our state in
    // `viewControllerWithRestorationIdentifierPath(_:coder:)` instead,
    // along with the controller instance itself.
    //
    // override func decodeRestorableStateWithCoder(coder: NSCoder)  {
    //     super.decodeRestorableStateWithCoder(coder)
    // }
}

// Note the extra protocol: This view controller is not initially created
// (before `application(_:willFinishLaunchingWithOptions:)` returns), so
// it may have to be created on demand for state restoration.
extension CityViewController: UIViewControllerRestoration {

    // Provide a new instance on demand, including decoding of its previous
    // state, which would otherwise be done in
    // `decodeRestorableStateWithCoder(coder:)`
    static func viewController(
        withRestorationIdentifierPath identifierComponents: [String],
        coder: NSCoder
    ) -> UIViewController? {
        assert(String(describing: self) == identifierComponents.last, "unexpected restoration path: \(identifierComponents)")

        // (this really needs to be NSString)
        // swiftlint:disable:next legacy_objc_type
        guard let restoredName = coder.decodeObject(of: NSString.self, forKey: encodingKeyCityName) else {
            print("decoding the city name failed")
            // it does not make sense to create an empty controller of this type:
            // abort state restoration at this point
            return nil
        }

        return self.init(cityName: restoredName as String)
    }
}
