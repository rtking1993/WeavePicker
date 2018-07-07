// MARK: ImageCell

class ImageCell: UICollectionViewCell, NibLoadable, ReusableCell {
    
    // MARK: Outlets
    
    @IBOutlet var imageView: UIImageView!
    
    // MARK: Cell Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    // MARK: Helper Methods
    
    func configure(with image: Image) {
        imageView.image = image.finalImage
    }
}
