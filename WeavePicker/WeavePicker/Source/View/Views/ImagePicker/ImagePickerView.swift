// MARK: Frameworks

import Photos

// MARK: ImagePickerViewDelegate

protocol ImagePickerViewDelegate: class {
    func imagePickerView(_ imagePickerView: ImagePickerView, didSelect image: Image?)
    func imagePickerView(_ imagePickerView: ImagePickerView, didDeselect image: Image?)
}

// MARK: ImagePickerView

class ImagePickerView: View {
    
    // MARK: Delegate
    
    weak var delegate: ImagePickerViewDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: Variables

    var assetSession = AssetSession()
    var assets = [PHAsset]()
    
    var album: Album? {
        didSet {
            setupImagesArray()
        }
    }
    
    // MARK: Constants
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    
    // MARK: Helper Methods
    
    func setupImagesArray() {
        assets = assetSession.fetchAssets(in: album)
        assets.reverse()
        refreshCollectionView()
    }
    
    func selectImage(at index: Int) {
        assetSession.fetchImageAt(index: index, in: assets) { image in
            self.delegate?.imagePickerView(self, didSelect: image)
        }
    }
    
    func deselectImage(at index: Int) {
        assetSession.fetchImageAt(index: index, in: assets) { image in
            self.delegate?.imagePickerView(self, didDeselect: image)
        }
    }
    
    func allowMultipleSelection(_ allow: Bool) {
        collectionView.allowsMultipleSelection = allow
    }
    
    private func refreshCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate Methods

extension ImagePickerView: UICollectionViewDataSource, UICollectionViewDelegate {
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AssetCell = collectionView.dequeueReusableCell(for: indexPath)
        let assetObject = assets[indexPath.row]
        cell.configure(with: assetObject, indexPath: indexPath)
        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectImage(at: indexPath.row)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        deselectImage(at: indexPath.row)
    }
}

// MARK: UICollectionViewDelegateFlowLayout Methods

extension ImagePickerView: UICollectionViewDelegateFlowLayout {
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = (sectionInsets.left + sectionInsets.right) * itemsPerRow
        let availableWidth = frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
