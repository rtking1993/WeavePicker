// MARK: CollectionViewListLayoutAttribute

class CollectionViewListLayoutAttribute: UICollectionViewLayoutAttributes {
    var contentViewLayoutMargins: UIEdgeInsets = .zero
    var hasAdjustedContentViewLayoutMargins: Bool = false

    override func copy(with zone: NSZone? = nil) -> Any {
        // swiftlint:disable force_cast
        let copy = super.copy(with: zone) as! CollectionViewListLayoutAttribute
        copy.contentViewLayoutMargins = contentViewLayoutMargins
        copy.hasAdjustedContentViewLayoutMargins = hasAdjustedContentViewLayoutMargins
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? CollectionViewListLayoutAttribute else {
            return false
        }

        guard super.isEqual(object) else {
            return false
        }

        guard contentViewLayoutMargins == object.contentViewLayoutMargins else {
            return false
        }

        guard hasAdjustedContentViewLayoutMargins == object.hasAdjustedContentViewLayoutMargins else {
            return false
        }

        return true
    }
}
