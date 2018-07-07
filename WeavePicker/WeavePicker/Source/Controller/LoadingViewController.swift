import UIKit

// MARK: LoadingViewController

class LoadingViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var loadingSpinnerView: UIView!
    
    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadingSpinnerView()
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
    
    private func setupLoadingSpinnerView() {
        let shape = CAShapeLayer()
        
        let shapeWidth = loadingSpinnerView.frame.width / 20
        let shapeHeight = loadingSpinnerView.frame.width / 4
        shape.frame.size = CGSize(width: shapeWidth, height: shapeHeight)
        shape.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        shape.path = CGPath(ellipseIn: shape.frame, transform: nil)
        shape.fillColor = UIColor.white.cgColor
        
        let replicator = CAReplicatorLayer()
        replicator.instanceCount = 20
        
        let fullCircle = CGFloat.pi * 2
        let angle = fullCircle / CGFloat(replicator.instanceCount)
        
        replicator.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        replicator.bounds.size = CGSize(width: shape.frame.height * .pi,
                                        height: shape.frame.height)
        
        replicator.addSublayer(shape)
        
        loadingSpinnerView.layer.addSublayer(replicator)
    }
}

/// MARK: LoadingViewControllerPresenter protocol.
/// It will modally present the loadingViewController

protocol LoadingViewControllerPresenter: class {
    var loadingViewController: LoadingViewController? { get set }
}

extension LoadingViewControllerPresenter where Self: UIViewController {
    
    func presentLoadingViewController(completionHandler completion: (() -> Void)?) {
        guard loadingViewController == nil else {
            return
        }
        
        loadingViewController = UIStoryboard.instantiateViewController()
        DispatchQueue.main.async {
            self.present(self.loadingViewController!, animated: true, completion: completion)
        }
    }
    
    func dismissLoadingViewController(completionHandler completion: (() -> Void)?) {
        guard let loadingViewController = loadingViewController else {
            return
        }
        
        DispatchQueue.main.async {
            loadingViewController.dismiss(animated: true, completion: completion)
        }
        self.loadingViewController = nil
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
