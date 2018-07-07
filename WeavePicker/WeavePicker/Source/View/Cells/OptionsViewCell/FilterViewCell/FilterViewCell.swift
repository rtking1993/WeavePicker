// MARK: FilterViewCellDelegate

protocol FilterViewCellDelegate: class {
    func filterViewCell(_ filterViewCell: FilterViewCell, didSelect filterType: FilterType)
}

// MARK: FilterViewCell

class FilterViewCell: UICollectionViewCell, NibLoadable, ReusableCell {
    
    // MARK: Delegate
    
    weak var delegate: FilterViewCellDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: Constants
    
    static let suggestedSize: CGSize = CGSize(width: 375, height: 275)
    private let sectionInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
    
    // MARK: Variables
    
    var sampleImage: UIImage? {
        didSet {
            refreshCollectionView()
        }
    }
    
    // MARK: View Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(cellClass: FilterCell.self)
    }
    
    // MARK: Helper Methods
    
    func configure(with sampleImage: UIImage?) {
        self.sampleImage = sampleImage
    }
    
    private func refreshCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate Methods

extension FilterViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FilterCell = collectionView.dequeueReusableCell(for: indexPath)
        let filter = filters[indexPath.row]
        let filteredImage = sampleImage?.adjustImage(with: filter.filterType)
        cell.configure(with: filter.title, image: filteredImage)
        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterViewCell(self, didSelect: filters[indexPath.row].filterType)
    }
}

// MARK: UICollectionViewDelegateFlowLayout Methods

extension FilterViewCell: UICollectionViewDelegateFlowLayout {
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = (sectionInsets.top + sectionInsets.bottom)
        let availableHeight = collectionView.frame.height - paddingSpace
        return CGSize(width: availableHeight, height: availableHeight)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
}
