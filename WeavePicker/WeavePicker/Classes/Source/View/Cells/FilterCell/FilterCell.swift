// MARK: FilterCell

class FilterCell: UICollectionViewCell, NibLoadable, ReusableCell {
    
    // MARK: Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    // MARK: Variables
    
    override var isSelected: Bool {
        didSet {
            updateSelection()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }
        }
    }
    
    // MARK: Cell Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        imageView.image = nil
    }
    
    // MARK: Configure Methods
    
    func configure(with title: String, image: UIImage?) {
        titleLabel.text = title
        titleLabel.font = .bodyScaled
        imageView.image = image
    }
    
    // MARK: Helper Methods
    
    private func updateSelection() {
        if isSelected {
            titleLabel.font = .boldBodyScaled
        } else {
            titleLabel.font = .bodyScaled
        }
    }
}
