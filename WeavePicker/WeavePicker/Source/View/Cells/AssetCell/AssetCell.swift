// MARK: Frameworks

import Photos

// MARK: AssetCell

class AssetCell: ListCollectionViewCell {
    
    // MARK: Outlets

    @IBOutlet var imageView: UIImageView!
    
    // MARK: Variables

    var manager = PHImageManager.default()
    var requestId: PHImageRequestID!
    
    override var isSelected: Bool {
        didSet {
            updateSelection()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateSelection()
        }
    }
    
    // MARK: View Methods
    
    override func prepareForReuse() {
        imageView.image = nil
        if let requestId = requestId {
            manager.cancelImageRequest(requestId)
        }
    }
    
    // MARK: Helper Methods

    func configure(with asset: PHAsset, indexPath: IndexPath) {
        self.tag = indexPath.item
        let options: PHImageRequestOptions = setupPHImageRequestOptions()
        let imageViewSize = imageView.frame.size
        
        // Dispatch the request to the user initiated thread,
        // which is the 2nd priority behind the main thread
        DispatchQueue.global(qos: .userInitiated).async {
            self.requestId = self.manager.requestImage(for: asset,
                                                  targetSize: imageViewSize,
                                                  contentMode: .aspectFit,
                                                  options: options,
                                                  resultHandler: {(result, _) in
                DispatchQueue.main.async {
                    if self.tag == indexPath.item {
                        self.imageView.image = result
                    }
                }
            })
        }
    }
    
    private func setupPHImageRequestOptions() -> PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.resizeMode = .fast
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        return options
    }
    
    private func updateSelection() {
        if isHighlighted || isSelected {
            imageView.alpha = 0.6
        } else {
            imageView.alpha = 1.0
        }
    }
}
