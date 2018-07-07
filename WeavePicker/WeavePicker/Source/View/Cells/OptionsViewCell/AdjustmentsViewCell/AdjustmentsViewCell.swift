// MARK: AdjustmentsViewCellDelegate

protocol AdjustmentsViewCellDelegate: class {
    func adjustmentsViewCell(_ adjustmentsViewCell: AdjustmentsViewCell, didChangeBrightness brightness: Float)
    func adjustmentsViewCell(_ adjustmentsViewCell: AdjustmentsViewCell, didChangeContrast contrast: Float)
    func adjustmentsViewCell(_ adjustmentsViewCell: AdjustmentsViewCell, didChangeSharpness sharpness: Float)
}

// MARK: AdjustmentsViewCell

class AdjustmentsViewCell: UICollectionViewCell, NibLoadable, ReusableCell {
    
    // MARK: Delegate
    
    weak var delegate: AdjustmentsViewCellDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var brightnessLabel: UILabel!
    @IBOutlet var brightnessSlider: UISlider!
    
    @IBOutlet var contrastLabel: UILabel!
    @IBOutlet var contrastSlider: UISlider!
    
    @IBOutlet var sharpnessLabel: UILabel!
    @IBOutlet var sharpnessSlider: UISlider!
    
    // MARK: Constants
    
    static var suggestedSize: CGSize = CGSize(width: 375, height: 275)
    
    // MARK: View Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setFonts()
        
        brightnessLabel.text = NSLocalizedString("Brightness", comment: "")
        contrastLabel.text = NSLocalizedString("Contrast", comment: "")
        sharpnessLabel.text = NSLocalizedString("Sharpness", comment: "")
    }
    
    // MARK: Action Methods
    
    @IBAction func changeBrightness(_ sender: Any?) {
        delegate?.adjustmentsViewCell(self, didChangeBrightness: brightnessSlider.value)
    }
    
    @IBAction func changeContrast(_ sender: Any?) {
        delegate?.adjustmentsViewCell(self, didChangeContrast: contrastSlider.value)
    }
    
    @IBAction func changeSharpness(_ sender: Any?) {
        delegate?.adjustmentsViewCell(self, didChangeSharpness: sharpnessSlider.value)
    }
    
    // MARK: Helper Methods
    
    func resetBrightness() {
        brightnessSlider.value = 0
    }
    
    func resetContrast() {
        contrastSlider.value = 1
    }
    
    func resetSharpness() {
        sharpnessSlider.value = 0.4
    }
    
    private func setFonts() {
        brightnessLabel.font = .bodyScaled
        contrastLabel.font = .bodyScaled
        sharpnessLabel.font = .bodyScaled
    }
}
