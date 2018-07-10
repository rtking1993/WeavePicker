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
        setupNavigationBar()
        
        setupImageFilterSession()
        setupFilteredImagesView()
        setupFilterOptionsView()
    }
    
    // MARK: Action Methods
    
    @IBAction func done(_ sender: Any?) {
        delegate?.imageEditViewController(self, didFinishEditing: images)
    }
    
    @IBAction func undo(_ sender: Any?) {
        imageFilterSession.removeLastStep()
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
    
    private func setupNavigationBar() {
        title = NSLocalizedString("Edit Photo", comment: "")
        let titleAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.actionScaled,
                                                             .foregroundColor: #colorLiteral(red: 0.01960784314, green: 0.1843137255, blue: 0.3725490196, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
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
    func imageFilterSession(_ imageFilterSession: ImageFilterSession, didUndo editStep: EditStep) {
        filterOptionsView.resetSlider(for: editStep)
    }
    
    func imageFilterSession(_ imageFilterSession: ImageFilterSession, didFinishEditing image: Image?) {
        filteredImagesView.imageAdjusted(image)
    }
}

// MARK: FilterViewDelegate Methods

extension ImageEditViewController: FilterOptionsViewDelegate {
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjust filterType: FilterType) {
        let filterStep: EditStep = EditStep(type: .filter,
                                          value: filterType)
        imageFilterSession.addStep(newEditStep: filterStep)
    }
    
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustBrightness brightness: Float) {
        let brightnessStep: EditStep = EditStep(type: .brightness,
                                            value: brightness)
        imageFilterSession.addStep(newEditStep: brightnessStep)
    }
    
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustContrast contrast: Float) {
        let contrastStep: EditStep = EditStep(type: .contrast,
                                            value: contrast)
        imageFilterSession.addStep(newEditStep: contrastStep)
    }
    
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustExposure exposure: Float) {
        let exposureStep: EditStep = EditStep(type: .exposure,
                                            value: exposure)
        imageFilterSession.addStep(newEditStep: exposureStep)
    }
    
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustHue hue: Float) {
        let hueStep: EditStep = EditStep(type: .hue,
                                            value: hue)
        imageFilterSession.addStep(newEditStep: hueStep)
    }
    
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustSaturation saturation: Float) {
        let saturationStep: EditStep = EditStep(type: .saturation,
                                            value: saturation)
        imageFilterSession.addStep(newEditStep: saturationStep)
    }
}
