/// `NibLoadable` is protocol that should be adopted by a `UIView` that is a view for a nib.
protocol NibLoadable: class {
    // Return the nib for the view.
    static var nib: UINib { get }
}

/// Default implementation of `NibLoadable`.
extension NibLoadable {
    static var nib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: Bundle(for: Self.self))
    }
}
