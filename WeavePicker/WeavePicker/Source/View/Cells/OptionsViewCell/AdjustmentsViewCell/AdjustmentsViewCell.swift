// MARK: AdjustmentsViewCellDelegate

protocol AdjustmentsViewCellDelegate: class {
    func adjustmentsViewCell(_ adjustmentsViewCell: AdjustmentsViewCell, didChangeBrightness brightness: Float)
    func adjustmentsViewCell(_ adjustmentsViewCell: AdjustmentsViewCell, didChangeExposure exposure: Float)
    func adjustmentsViewCell(_ adjustmentsViewCell: AdjustmentsViewCell, didChangeContrast contrast: Float)
}

// MARK: AdjustmentsViewCell

class AdjustmentsViewCell: UICollectionViewCell, NibLoadable, ReusableCell {
    
    // MARK: Delegate
    
    weak var delegate: AdjustmentsViewCellDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var brightnessLabel: UILabel!
    @IBOutlet var brightnessSlider: UISlider!
    
    @IBOutlet var exposureLabel: UILabel!
    @IBOutlet var exposureSlider: UISlider!
    
    @IBOutlet var contrastLabel: UILabel!
    @IBOutlet var contrastSlider: UISlider!
    
    // MARK: Constants
    
    static var suggestedSize: CGSize = CGSize(width: 375, height: 275)
    
    // MARK: View Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setFonts()
        
        brightnessLabel.text = NSLocalizedString("Brightness", comment: "")
        exposureLabel.text = NSLocalizedString("Exposure", comment: "")
        contrastLabel.text = NSLocalizedString("Contrast", comment: "")
    }
    
    // MARK: Action Methods
    
    @IBAction func changeBrightness(_ sender: Any?) {
        delegate?.adjustmentsViewCell(self, didChangeBrightness: brightnessSlider.value)
    }
    
    @IBAction func changeExposure(_ sender: Any?) {
        delegate?.adjustmentsViewCell(self, didChangeExposure: exposureSlider.value)
    }
    
    @IBAction func changeContrast(_ sender: Any?) {
        delegate?.adjustmentsViewCell(self, didChangeContrast: contrastSlider.value)
    }
    
    // MARK: Helper Methods
    
    func resetBrightness() {
        brightnessSlider.value = 0
    }
    
    func resetExposure() {
        exposureSlider.value = 0
    }
    
    func resetContrast() {
        contrastSlider.value = 1
    }
    
    private func setFonts() {
        brightnessLabel.font = .bodyScaled
        exposureLabel.font = .bodyScaled
        contrastLabel.font = .bodyScaled
    }
}
