// MARK: Frameworks

import Photos

// MARK: ImagePickerViewControllerDelegate

protocol ImagePickerViewControllerDelegate: class {
    func imagePickerViewControllerDidCancel(_ imagePickerViewController: ImagePickerViewController)
    func imagePickerViewControllerNotAuthorized(_ imagePickerViewController: ImagePickerViewController)
}

// MARK: ImagePickerViewController

class ImagePickerViewController: UIViewController, LoadingViewControllerPresenter {
    
    // MARK: Delegate
    
    weak var delegate: ImagePickerViewControllerDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var multipleSelectButton: UIButton!
    @IBOutlet var pickerView: ImagePickerView!
    
    // MARK: Variables
    
    var startIndex: Int?
    var loadingViewController: LoadingViewController?
    var selectedImages: [Image] = [] {
        didSet {
            setMainImage()
        }
    }
    
    // MARK: View Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        checkPhotoLibraryPermission()
        setupPickerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pickerView.collectionView.selectItem(at: IndexPath(row: 0, section: 0),
                                             animated: true,
                                             scrollPosition: .bottom)
    }
    
    // MARK: Cell Methods
    
    private func setupPickerView() {
        registerCells()
        pickerView.delegate = self
        pickerView.setupImagesArray()
        pickerView.selectImage(at: 0)
    }
    
    private func registerCells() {
        pickerView.collectionView.register(cellClass: AssetCell.self)
    }
    
    // MARK: Action Methods

    @IBAction func next(_ sender: Any?) {
        showImageFilterViewController()
    }
    
    @IBAction func cancel(_ sender: Any?) {
        delegate?.imagePickerViewControllerDidCancel(self)
    }
    
    @IBAction func albumPicker(_ sender: Any?) {
        presentAlbumPickerViewController()
    }
    
    @IBAction func multipleSelect(_ sender: Any?) {
        let allowMultipleSelection = !multipleSelectButton.isSelected
        multipleSelectButton.isSelected = allowMultipleSelection
        pickerView.allowMultipleSelection(allowMultipleSelection)
    }
    
    // MARK: Helper Methods
    
    private func showImageFilterViewController() {
        DispatchQueue.main.async {
            let imageEditViewController: ImageEditViewController = UIStoryboard.instantiateViewController()
            imageEditViewController.delegate = self.navigationController as? ImageEditViewControllerDelegate
            imageEditViewController.images = self.selectedImages
            self.show(imageEditViewController, sender: self)
        }
    }
    
    private func presentAlbumPickerViewController() {
        DispatchQueue.main.async {
            let albumPickerViewController: AlbumPickerViewController = UIStoryboard.instantiateViewController()
            albumPickerViewController.delegate = self
            self.present(albumPickerViewController, animated: true, completion: nil)
        }
    }
    
    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            break
        case .denied, .restricted :
            delegate?.imagePickerViewControllerNotAuthorized(self)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ status in
                switch status {
                case .authorized:
                    self.setupPickerView()
                case .denied, .restricted:
                    self.delegate?.imagePickerViewControllerNotAuthorized(self)
                case .notDetermined:
                    self.delegate?.imagePickerViewControllerNotAuthorized(self)
                }
            })
        }
    }
    
    private func setMainImage() {
        DispatchQueue.main.async {
            self.imageView.image = self.selectedImages.last?.originalImage
        }
    }
}

// MARK: PickerViewDelegate Methods

extension ImagePickerViewController: ImagePickerViewDelegate {
    func imagePickerView(_ imagePickerView: ImagePickerView, didSelect image: Image?) {
        if let image = image {
            selectedImages.append(image)
        }
    }
    
    func imagePickerView(_ imagePickerView: ImagePickerView, didDeselect image: Image?) {
        if let image = image,
           let index = selectedImages.index(of: image) {
            selectedImages.remove(at: index)
        }
    }
}

// MARK: AlbumPickerViewControllerDelegate Methods

extension ImagePickerViewController: AlbumPickerViewControllerDelegate {
    func albumPickerViewController(_ albumPickerViewController: AlbumPickerViewController, didSelect album: Album) {
        title = album.title
        pickerView.album = album
        albumPickerViewController.dismiss(animated: true, completion: nil)
    }
    
    func albumPickerViewControllerDidSelectCancel(_ albumPickerViewController: AlbumPickerViewController) {
        albumPickerViewController.dismiss(animated: true, completion: nil)
    }
}
