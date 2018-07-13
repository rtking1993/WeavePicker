// MARK: Frameworks

import Photos

// MARK: AlbumPickerViewControllerDelegate

protocol AlbumPickerViewControllerDelegate: class {
    func albumPickerViewControllerDidSelectCancel(_ albumPickerViewController: AlbumPickerViewController)
    func albumPickerViewController(_ albumPickerViewController: AlbumPickerViewController, didSelect album: Album)
}

// MARK: AlbumPickerViewController

class AlbumPickerViewController: UIViewController, LoadingViewControllerPresenter {
    
    // MARK: Delegate
    
    weak var delegate: AlbumPickerViewControllerDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var emptyView: EmptyView!
    
    // MARK: Variables
    
    var loadingViewController: LoadingViewController?
    var albumPickerPresenter: AlbumPickerPresenter!
    var albums: [Album] = [] {
        didSet {
            refreshCollectionView()
        }
    }

    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()

        albumPickerPresenter = AlbumPickerPresenter()
        albumPickerPresenter.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentLoadingViewController {
            self.albumPickerPresenter.albumPickerInteractor.observeAlbums()
        }
    }
    
    // MARK: Action Methods
    
    @IBAction func cancel(_ sender: Any?) {
        delegate?.albumPickerViewControllerDidSelectCancel(self)
    }
    
    // MARK: Helper Methods
    
    private func setupViewController() {
        setupNavigationBar()
        setupEmptyView()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        title = NSLocalizedString("Albums", comment: "")
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupCollectionView() {
        collectionView.register(cellClass: AlbumCell.self)
    }
    
    private func setupEmptyView() {
        emptyView.message = NSLocalizedString("Something went wrong and no photo albums could be found.", comment: "")
    }
    
    private func refreshCollectionView() {
        emptyView.isHidden = albums.count > 0
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}

// MARK: UICollectionViewDelegate and UICollectionViewDataSource Methods

extension AlbumPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AlbumCell = collectionView.dequeueReusableCell(for: indexPath)
        let albumViewModel = AlbumViewModel(album: albums[indexPath.row])
        cell.configure(with: albumViewModel)
        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.albumPickerViewController(self, didSelect: albums[indexPath.row])
    }
}

// MARK: UICollectionViewDelegateFlowLayout Methods

extension AlbumPickerViewController: UICollectionViewDelegateFlowLayout {
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: AlbumCell.suggestedSize.height)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: AlbumPickerPresenterDelegate

extension AlbumPickerViewController: AlbumPickerPresenterDelegate {
    func albumPickerPresenter(_ albumPickerPresenter: AlbumPickerPresenter, show albums: [Album]) {
        dismissLoadingViewController(completionHandler: nil)
        self.albums = albums
    }
}
