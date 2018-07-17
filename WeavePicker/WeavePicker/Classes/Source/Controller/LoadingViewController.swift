// MARK: LoadingViewController

class LoadingViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var loadingActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var loadingLabel: UILabel!

    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFonts()
        loadingLabel.text = NSLocalizedString("Loading", comment: "")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Helper Methods
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    private func setFonts() {
        loadingLabel.font = .bodyScaled
    }
}

/// MARK: LoadingViewControllerPresenter protocol.
/// It will modally present the loadingViewController

protocol LoadingViewControllerPresenter: class {
    var loadingViewController: LoadingViewController? { get set }
}

extension LoadingViewControllerPresenter where Self: UIViewController {
    
    func presentLoadingViewController(completionHandler completion: (() -> Void)?) {
        DispatchQueue.main.async {
            guard self.loadingViewController == nil else {
                return
            }
        
            self.loadingViewController = UIStoryboard.instantiateViewController()
            self.present(self.loadingViewController!, animated: true, completion: completion)
        }
    }
    
    func dismissLoadingViewController(completionHandler completion: (() -> Void)?) {
        DispatchQueue.main.async {
            guard let loadingViewController = self.loadingViewController else {
                return
            }
            
            loadingViewController.dismiss(animated: true, completion: completion)
            self.loadingViewController = nil
        }
    }
}

/// MARK: LoadingViewControllerContainer protocol

/// It will present the loadingViewController as a child of the
/// current UIViewController
protocol LoadingViewControllerContainer: class {
    var loadingViewController: LoadingViewController? { get set }
}

extension LoadingViewControllerContainer where Self: UIViewController {
    func showLoadingViewController() {
        guard loadingViewController == nil else {
            return
        }
        
        loadingViewController = UIStoryboard.instantiateViewController()
        addChildViewController(loadingViewController!)
        loadingViewController!.view.frame = view.bounds
        view.addSubview(loadingViewController!.view)
        loadingViewController!.didMove(toParentViewController: self)
    }
    
    func hideLoadingViewController() {
        guard let loadingViewController = loadingViewController else {
            return
        }
        
        loadingViewController.willMove(toParentViewController: nil)
        loadingViewController.view.removeFromSuperview()
        loadingViewController.removeFromParentViewController()
        self.loadingViewController = nil
    }
}
