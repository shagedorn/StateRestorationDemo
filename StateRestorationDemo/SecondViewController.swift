import UIKit

final class SecondViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var citySelectionControl: UISegmentedControl?

    private static let cities = ["Dresden", "Cologne"]

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
        tabBarItem = UITabBarItem(title: "Second", image: .init(named: "second"), tag: 0)

        // For explanation, see `FirstViewController.swift`
        restorationIdentifier = String(describing: type(of: self))
    }

    // MARK: - Lifecycle and actions

    override func viewDidLoad() {
        super.viewDidLoad()
        citySelectionControl?.setTitle(Self.cities.first, forSegmentAt: 0)
        citySelectionControl?.setTitle(Self.cities.last, forSegmentAt: 1)

        updateImage()
    }

    private func updateImage() {
        guard let citySelectionControl else {
            return
        }

        let selectedIndex = (citySelectionControl.selectedSegmentIndex == UISegmentedControl.noSegment) ? 0 : citySelectionControl.selectedSegmentIndex

        guard Self.cities.indices ~= selectedIndex else {
            assertionFailure("selected index '\(selectedIndex)' is out of bounds.")
            return
        }

        let selectedCityImage = UIImage(named: Self.cities[selectedIndex])
        imageView?.image = selectedCityImage
    }

    @IBAction private func selectionChanged(from sender: UISegmentedControl) {
        updateImage()
    }

    @IBAction private func chooseCity(from sender: UIButton) {
        guard let citySelectionControl else {
            assertionFailure("citySelectionControl not loaded")
            return
        }

        let selectedIndex = citySelectionControl.selectedSegmentIndex

        guard Self.cities.indices ~= selectedIndex else {
            assertionFailure("selected index '\(selectedIndex)' is out of bounds.")
            return
        }

        let cityController = CityViewController(cityName: Self.cities[selectedIndex])
        navigationController?.pushViewController(cityController, animated: true)
    }

    // MARK: - State Restoration

    // For explanation, see `FirstViewController.swift`

    private static let encodingKeySegmentIndex = "encodingKeySegmentIndex"

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        guard let citySelectionControl, isViewLoaded else {
            return
        }

        coder.encode(citySelectionControl.selectedSegmentIndex, forKey: Self.encodingKeySegmentIndex)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        assert(
            isViewLoaded,
            "We assume the controller is never restored without loading its view first."
        )
        citySelectionControl?.selectedSegmentIndex = coder.decodeInteger(forKey: Self.encodingKeySegmentIndex)
        updateImage()
    }

}
