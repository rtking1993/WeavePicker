// MARK: FilterOptionsViewDelegate

protocol FilterOptionsViewDelegate: class {
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjust filterType: FilterType)
    
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustBrightness brightness: Float)
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustContrast contrast: Float)
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustSharpness sharpness: Float)
    
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustHue hue: Float)
    func filterOptionsView(_ filterOptionsView: FilterOptionsView, didAdjustSaturation saturation: Float)

}

// MARK: FilterOptionsView

class FilterOptionsView: View {
    
    // MARK: Delegate
    
    weak var delegate: FilterOptionsViewDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var filtersButton: UIButton!
    @IBOutlet var adjustmentsButton: UIButton!
    @IBOutlet var colorsButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: Variables
    
    var image: Image? {
        didSet {
            refreshCollectionView()
        }
    }
    
    // MARK: View Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(cellClass: FilterViewCell.self)
        collectionView.register(cellClass: AdjustmentsViewCell.self)
        collectionView.register(cellClass: ColorViewCell.self)
    }
    
    // MARK: Action Methods
    
    @IBAction func optionsChange(_ sender: Any?) {
        guard let optionButton: UIButton = sender as? UIButton else {
            return
        }
        
        deselectAllOptionButtons()
        optionButton.isSelected = true
        
        switch optionButton {
        case filtersButton:
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        case adjustmentsButton:
            collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
        case colorsButton:
            collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: true)
        default:
            break
        }
    }
    
    // MARK: Helper Methods
    
    func resetSlider(for editStep: EditStep) {
        if let adjustmentViewCell = collectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? AdjustmentsViewCell {
            switch editStep.type {
            case .brightness:
                adjustmentViewCell.resetBrightness()
            case .contrast:
                adjustmentViewCell.resetContrast()
            case .sharpness:
                adjustmentViewCell.resetSharpness()
            default:
                break
            }
        }
        
        if let colorViewCell = collectionView.cellForItem(at: IndexPath(row: 2, section: 0)) as? ColorViewCell {
            switch editStep.type {
            case .hue:
                colorViewCell.resetHue()
            case .saturation:
                colorViewCell.resetSaturation()
            default:
                break
            }
        }
    }
    
    private func refreshCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func deselectAllOptionButtons() {
        filtersButton.isSelected = false
        adjustmentsButton.isSelected = false
        colorsButton.isSelected = false
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate Methods

extension FilterOptionsView: UICollectionViewDataSource, UICollectionViewDelegate {
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell: FilterViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(with: image?.sampleImage)
            return cell
        case 1:
            let cell: AdjustmentsViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case 2:
            let cell: ColorViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout Methods

extension FilterOptionsView: UICollectionViewDelegateFlowLayout {
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
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

// MARK: FilterViewCellDelegate Methods

extension FilterOptionsView: FilterViewCellDelegate {
    func filterViewCell(_ filterViewCell: FilterViewCell, didSelect filterType: FilterType) {
        delegate?.filterOptionsView(self, didAdjust: filterType)
    }
}

// MARK: AdjustmentsViewCellDelegate Methods

extension FilterOptionsView: AdjustmentsViewCellDelegate {
    func adjustmentsViewCell(_ adjustmentsViewCell: AdjustmentsViewCell, didChangeBrightness brightness: Float) {
        delegate?.filterOptionsView(self, didAdjustBrightness: brightness)
    }
    
    func adjustmentsViewCell(_ adjustmentsViewCell: AdjustmentsViewCell, didChangeContrast contrast: Float) {
        delegate?.filterOptionsView(self, didAdjustContrast: contrast)
    }
    
    func adjustmentsViewCell(_ adjustmentsViewCell: AdjustmentsViewCell, didChangeSharpness sharpness: Float) {
        delegate?.filterOptionsView(self, didAdjustSharpness: sharpness)
    }
}

// MARK: ColorViewCellDelegate Methods

extension FilterOptionsView: ColorViewCellDelegate {
    func colorViewCellDid(_ colorViewCell: ColorViewCell, didChangeHue hue: Float) {
        delegate?.filterOptionsView(self, didAdjustHue: hue)
    }
    
    func colorViewCellDid(_ colorViewCell: ColorViewCell, didChangeSaturation saturation: Float) {
        delegate?.filterOptionsView(self, didAdjustSaturation: saturation)
    }
}
