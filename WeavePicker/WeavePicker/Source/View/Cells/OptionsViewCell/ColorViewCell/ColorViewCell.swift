// MARK: ColorViewCellDelegate

protocol ColorViewCellDelegate: class {
    func colorViewCellDid(_ colorViewCell: ColorViewCell, didChangeHue hue: Float)
    func colorViewCellDid(_ colorViewCell: ColorViewCell, didChangeSaturation saturation: Float)
}

// MARK: ColorViewCell

class ColorViewCell: UICollectionViewCell, NibLoadable, ReusableCell {
    
    // MARK: Delegate
    
    weak var delegate: ColorViewCellDelegate?

    // MARK: Outlets
    
    @IBOutlet var hueLabel: UILabel!
    @IBOutlet var hueSlider: UISlider!
    
    @IBOutlet var saturationLabel: UILabel!
    @IBOutlet var saturationSlider: UISlider!
    
    // MARK: Constants
    
    static var suggestedSize: CGSize = CGSize(width: 375, height: 275)
    
    // MARK: View Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setFonts()
        
        hueLabel.text = NSLocalizedString("Hue", comment: "")
        saturationLabel.text = NSLocalizedString("Saturation", comment: "")
    }
    
    // MARK: Action Methods
    
    @IBAction func changeHue(_ sender: Any?) {
        delegate?.colorViewCellDid(self, didChangeHue: hueSlider.value)
    }
    
    @IBAction func changeSaturation(_ sender: Any?) {
        delegate?.colorViewCellDid(self, didChangeSaturation: saturationSlider.value)
    }
    
    // MARK: Helper Methods
    
    func resetHue() {
        hueSlider.value = 0
    }
    
    func resetSaturation() {
        saturationSlider.value = 1
    }
    
    private func setFonts() {
        saturationLabel.font = .bodyScaled
    }
}
