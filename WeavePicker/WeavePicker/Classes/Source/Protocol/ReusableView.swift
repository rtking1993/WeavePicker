/// `ReusableView` is protocol that should be adopted by a `UICollectionReusableView` that is reusable.
///
/// Example:
/// class HeaderReusableView: UICollectionReusableView, ReusableView {
///    static var supplementaryViewKind: String {
///       return UICollectionElementKindSectionHeader
///    }
/// }

protocol ReusableView: class {
    // Return the reuse identifier for the cell.
    static var reuseIdentifier: String { get }

    static var supplementaryViewKind: String { get }
}

/// Default implementation of `ReusableView`.
extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

/// Extension to `UICollectionView` for registering a `ReusableView`.
extension UICollectionView {
    // swiftlint:disable generic_type_name
    func register<CollectionViewReusableView: UICollectionReusableView>(reusableViewClass: CollectionViewReusableView.Type) where CollectionViewReusableView: ReusableView, CollectionViewReusableView: NibLoadable {
        register(reusableViewClass.nib, forSupplementaryViewOfKind: reusableViewClass.supplementaryViewKind, withReuseIdentifier: reusableViewClass.reuseIdentifier)
    }

    // swiftlint:disable generic_type_name
    func register<CollectionViewReusableView: UICollectionReusableView>(reusableViewClass: CollectionViewReusableView.Type) where CollectionViewReusableView: ReusableView {
        register(reusableViewClass.self, forSupplementaryViewOfKind: reusableViewClass.supplementaryViewKind, withReuseIdentifier: reusableViewClass.reuseIdentifier)
    }
}

/// Extension to `UICollectionView` for dequeuing a `ReusableView`.
extension UICollectionView {
    // swiftlint:disable generic_type_name
    func dequeueReusableView<CollectionViewReusableView: ReusableView>(for indexPath: IndexPath) -> CollectionViewReusableView where CollectionViewReusableView: UICollectionReusableView {
        // swiftlint:disable force_cast
        return dequeueReusableSupplementaryView(ofKind:
            CollectionViewReusableView.supplementaryViewKind, withReuseIdentifier: CollectionViewReusableView.reuseIdentifier, for: indexPath) as! CollectionViewReusableView
    }
}
