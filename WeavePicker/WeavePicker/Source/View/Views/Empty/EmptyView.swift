// MARK: ConfigurableEmptyView

protocol ConfigurableEmptyView {
    func configure(with message: String)
}

// MARK: EmptyView

class EmptyView: View {
    
    // MARK: Outlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    // MARK: Variables
    
    var title: String = NSLocalizedString("Nothing to see here", comment: "")
    var message: String = "" {
        didSet {
            messageLabel.text = message
        }
    }
    
    // MARK: View Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = title
        titleLabel.font = .actionScaled
        messageLabel.text = message
        messageLabel.font = .bodyScaled
    }
}
