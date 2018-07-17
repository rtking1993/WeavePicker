// MARK: View

class View: UIView {
    
    // MARK: Outlets
    
    @IBOutlet var contentView: UIView!

    // MARK: Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        let className = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        let classbundle = Bundle(for: View.self)
        classbundle.loadNibNamed(className, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
