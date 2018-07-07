// MARK: ImageEditViewControllerDelegate

protocol ImageEditViewControllerDelegate: class {
    func imageEditViewController(_ imageEditViewController: ImageEditViewController, didFinishEditing images: [Image])
}

// MARK: ImageEditViewController

class ImageEditViewController: UIViewController {
    
    // MARK: Delegate
    
    weak var delegate: ImageEditViewControllerDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var filteredImagesView: FilteredImagesView!
    @IBOutlet var filterOptionsView: FilterOptionsView!
    @IBOutlet var undoButton: UIButton!

    // MARK: Variables
    
    var images: [Image] = []
    var imageFilterSession = ImageFilterSession()
    
    // MARK: Constants
    
    private let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    private let itemsPerRow: CGFloat = 4
    
    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()

        setupImageFilterSession()
        setupFilteredImagesView()
        setupFilterOptionsView()
    }
    
    // MARK: Action Methods
    
    @IBAction func done(_ sender: Any?) {
        delegate?.imageEditViewController(self, didFinishEditing: images)
    }
    
    @IBAction func undo(_ sender: Any?) {
        imageFilterSession.removeLastEditStep()
    }
    
    // MARK: Helper Methods
    
    private func setupImageFilterSession() {
        imageFilterSession.delegate = self
        imageFilterSession.image = images.first
    }
    
    private func setupFilteredImagesView() {
        filteredImagesView.delegate = self
        filteredImagesView.configure(with: images)
    }
    
    private func setupFilterOptionsView() {
        filterOptionsView.delegate = self
        imageFilterSession.image = images.first
        filterOptionsView.image = images.first
    }
    
    private func registerCells() {
        filterOptionsView.collectionView.register(cellClass: FilterCell.self)
    }
}

// MARK: FilteredImagesViewDelegate Methods

extension ImageEditViewController: FilteredImagesViewDelegate {
    func filteredImagesView(_ filteredImagesView: FilteredImagesView, didSelect image: Image) {
        imageFilterSession.image = image
        filterOptionsView.image = image
    }
}

// MARK: ImageFilterSessionDelegate Methods

extension ImageEditViewController: ImageFilterSessionDelegate {
    func imageFilterSession(_ imageFilterSession: ImageFilterSession, didUndoEditStep editStep: EditStep) {
        filterOptionsView.resetSlider(for: editStep)
    }
    
    func imageFilterSession(_ imageFilterSession: ImageFilterSession, didFinishEditing image: Image?) {
        filteredImagesView.imageAdjusted(image)
    }
}

// MARK: FilterViewDelegate Methods

extension ImageEditViewController: FilterOptionsViewDelegate {
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjust filterType: FilterType?) {
        imageFilterSession.adjustImage(with: .filter,
                                       value: filterType)
    }
    
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustBrightness brightness: Float) {
        imageFilterSession.adjustImage(with: .brightness,
                                       value: brightness)
    }
    
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustContrast contrast: Float) {
        imageFilterSession.adjustImage(with: .contrast,
                                       value: contrast)
    }
    
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustSharpness sharpness: Float) {
        imageFilterSession.adjustImage(with: .sharpness,
                                       value: sharpness)
    }
    
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustHue hue: Float) {
        imageFilterSession.adjustImage(with: .hue,
                                       value: hue)
    }
    
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustSaturation saturation: Float) {
        imageFilterSession.adjustImage(with: .saturation,
                                       value: saturation)
    }
}
