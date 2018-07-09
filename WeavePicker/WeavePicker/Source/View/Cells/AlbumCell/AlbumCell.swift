// MARK: Frameworks

import Photos

// MARK: AlbumViewModel

class AlbumCell: ListCollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!    
    
    // MARK: Constants
    
    static var suggestedSize: CGSize = CGSize(width: 320, height: 90)
    
    // MARK: Variables
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setFonts()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = nil
        countLabel.text = nil
    }
    
    // MARK: Configure Methods
    
    func configure(with albumViewModel: AlbumViewModel) {
        imageView.image = albumViewModel.thumbnail
        titleLabel.text = albumViewModel.title
        countLabel.text = albumViewModel.count
    }
    
    // MARK: Helper Methods
    
    private func setFonts() {
        titleLabel.font = .bodyScaled
        countLabel.font = .captionScaled
    }
    
    private func updateSelection() {
        if isHighlighted || isSelected {
            backgroundColor = #colorLiteral(red: 0.92, green: 0.92, blue: 0.93, alpha: 1)
        } else {
            backgroundColor = .white
        }
    }
}
