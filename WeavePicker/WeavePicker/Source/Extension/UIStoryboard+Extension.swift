// MARK: UIStoryboard Extension

extension UIStoryboard {
    
    /// Initantiates a new instance of a UIViewController from a Storyboard.
    ///
    /// Note: The storyboard and view controller identifier is assumed to match the class name.
    class func instantiateViewController<T: UIViewController>() -> T {
        let identifier = NSStringFromClass(T.self).components(separatedBy: ".").last!
        let storyboardBundle = Bundle(for: T.self)
        let storyboard = UIStoryboard(name: identifier, bundle: storyboardBundle)
        // swiftlint:disable force_cast
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}
