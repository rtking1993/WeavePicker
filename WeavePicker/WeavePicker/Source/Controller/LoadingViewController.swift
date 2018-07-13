import UIKit

// MARK: LoadingViewController

class LoadingViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var loadingSpinnerView: UIView!
    @IBOutlet var loadingLabel: UILabel!

    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFonts()
        loadingLabel.text = NSLocalizedString("Loading", comment: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupLoadingSpinnerView()
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
    
    private func setupLoadingSpinnerView() {
        let shapeWidth: CGFloat = loadingSpinnerView.frame.width / 16
        let shapeHeight: CGFloat = loadingSpinnerView.frame.width / 4
        let animationDuration: TimeInterval = 1.2
        let instanceCount: Int = 12

        let shape = CAShapeLayer()
        shape.frame.size = CGSize(width: shapeWidth, height: shapeHeight)
        shape.anchorPoint = CGPoint(x: 0.5, y: 1)

        shape.path = CGPath(ellipseIn: shape.frame, transform: nil)
        shape.fillColor = UIColor.white.cgColor

        let replicator = CAReplicatorLayer()
        replicator.instanceCount = instanceCount

        let fullCircle = CGFloat.pi * 2
        let angle = fullCircle / CGFloat(instanceCount)

        replicator.instanceTransform = CATransform3DMakeRotation(-angle, 0, 0, 1)
        replicator.instanceDelay = CFTimeInterval(animationDuration / TimeInterval(instanceCount))
        
        replicator.frame = loadingSpinnerView.frame
        replicator.bounds.size = CGSize(width: shape.frame.height * .pi,
                                        height: shape.frame.height)

        replicator.addSublayer(shape)
        replicator.position = CGPoint(x: loadingSpinnerView.bounds.midX,
                                      y: loadingSpinnerView.bounds.midY)
        
        rotateAnimation(animationDuration: animationDuration, layer: shape)
        loadingSpinnerView.layer.addSublayer(replicator)
    }
    
    func rotateAnimation(animationDuration: TimeInterval, layer: CALayer) {
        layer.opacity = 0.0
        DispatchQueue.main.async {
            let rotateAnimation = CABasicAnimation(keyPath: "opacity")
            rotateAnimation.fromValue = 1.0
            rotateAnimation.toValue = 0.0
            rotateAnimation.duration = animationDuration
            rotateAnimation.repeatCount = .infinity
            layer.add(rotateAnimation, forKey: nil)
        }
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
