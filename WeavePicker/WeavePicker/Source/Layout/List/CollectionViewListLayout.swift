// MARK: CollectionViewListLayoutDelegate

protocol CollectionViewListLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, collectionViewListLayout: CollectionViewListLayout, estimatedHeightForItemAt indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, collectionViewListLayout: CollectionViewListLayout, estimatedHeightForSupplementaryViewFor section: Int) -> CGFloat?
}

// MARK: CollectionViewListLayout

class CollectionViewListLayout: UICollectionViewLayout {

    // MARK: Delegate

    weak var delegate: CollectionViewListLayoutDelegate?

    // MARK: Variables

    @IBInspectable var estimatedRowHeight: CGFloat = 44
    @IBInspectable var cellContentViewLayoutMarginsFollowReadableWidth: Bool = true

    private var layoutAttributesForItems: [CollectionViewListLayoutAttribute] = []
    private var layoutAttributesForSupplementaryViews: [CollectionViewListLayoutAttribute] = []

    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }

        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override class var invalidationContextClass: AnyClass {
        return CollectionViewListLayoutInvalidationContext.self
    }

    // MARK: Methods

    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        // swiftlint:disable force_cast
        let invalidationContext = context as! CollectionViewListLayoutInvalidationContext

        super.invalidateLayout(with: context)

        if invalidationContext.invalidatedBecauseOfBoundsChange || invalidationContext.invalidateEverything {
            layoutAttributesForItems = []
            layoutAttributesForSupplementaryViews = []
        }
    }

    override func prepare() {
        guard layoutAttributesForItems.isEmpty,
              layoutAttributesForSupplementaryViews.isEmpty else {
            return
        }

        initalLayout()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        for attributes in layoutAttributesForItems {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }

        for attributes in layoutAttributesForSupplementaryViews {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }

        return visibleLayoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }

        guard newBounds.size != collectionView.frame.size else {
            return false
        }

        return true
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        // swiftlint:disable force_cast
        let context = super.invalidationContext(forBoundsChange: newBounds) as! CollectionViewListLayoutInvalidationContext

        context.invalidatedBecauseOfBoundsChange = true

        return context
    }

    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {

        if preferredAttributes.frame.size.height == originalAttributes.frame.size.height && originalAttributes.frame.size.width == contentWidth {
            return false
        }

        return true
    }

    override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {

        guard let existingOriginalAttributes = originalAttributes as? CollectionViewListLayoutAttribute,
            let existingPreferredAttributes = preferredAttributes as? CollectionViewListLayoutAttribute else {
            // swiftlint:disable force_cast
            let context = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes) as! CollectionViewListLayoutInvalidationContext

            return context
        }

        if layoutAttributesForItems.contains(existingOriginalAttributes) {
            return invalidationContextForItem(forPreferredLayoutAttributes: existingPreferredAttributes, withOriginalAttributes: existingOriginalAttributes)
        } else if layoutAttributesForSupplementaryViews.contains(existingOriginalAttributes) {
            return invalidationContextForSupplementaryView(forPreferredLayoutAttributes: existingPreferredAttributes, withOriginalAttributes: existingOriginalAttributes)
        } else {
            // swiftlint:disable force_cast
            let context = super.invalidationContext(forPreferredLayoutAttributes: existingPreferredAttributes, withOriginalAttributes: existingOriginalAttributes) as! CollectionViewListLayoutInvalidationContext

            return context
        }
    }

    func invalidationContextForItem(forPreferredLayoutAttributes preferredAttributes: CollectionViewListLayoutAttribute, withOriginalAttributes originalAttributes: CollectionViewListLayoutAttribute) -> UICollectionViewLayoutInvalidationContext {
        // swiftlint:disable force_cast
        let context = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes) as! CollectionViewListLayoutInvalidationContext

        guard let originalAttributesIndex = layoutAttributesForItems.index(of: originalAttributes) else {
            return context
        }

        let contentHeightAdjustment: CGFloat = preferredAttributes.frame.size.height - originalAttributes.frame.size.height

        let attributes = layoutAttributesForItems[originalAttributesIndex]
        attributes.frame.size.height += contentHeightAdjustment
        attributes.frame.size.width = contentWidth

        context.invalidateItems(at: [attributes.indexPath])

        layoutAttributesForItems[originalAttributesIndex] = attributes

        for layoutAttributesForItem in layoutAttributesForItems {
            if layoutAttributesForItem.indexPath.section < originalAttributes.indexPath.section {
                continue
            }

            if layoutAttributesForItem.indexPath.section == originalAttributes.indexPath.section &&
                layoutAttributesForItem.indexPath.row <= originalAttributes.indexPath.row {
                continue
            }

            layoutAttributesForItem.frame.origin.y += contentHeightAdjustment
            context.invalidateItems(at: [layoutAttributesForItem.indexPath])
        }

        for layoutAttributesForSupplementaryView in layoutAttributesForSupplementaryViews {
            if layoutAttributesForSupplementaryView.indexPath.section <= originalAttributes.indexPath.section {
                continue
            }

            layoutAttributesForSupplementaryView.frame.origin.y += contentHeightAdjustment
            context.invalidateItems(at: [layoutAttributesForSupplementaryView.indexPath])
        }

        contentHeight = layoutAttributesForItems.last?.frame.maxY ?? 0

        return context
    }

    func invalidationContextForSupplementaryView(forPreferredLayoutAttributes preferredAttributes: CollectionViewListLayoutAttribute, withOriginalAttributes originalAttributes: CollectionViewListLayoutAttribute) -> UICollectionViewLayoutInvalidationContext {
        // swiftlint:disable force_cast
        let context = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes) as! CollectionViewListLayoutInvalidationContext

        guard let originalAttributesIndex = layoutAttributesForSupplementaryViews.index(of: originalAttributes) else {
            return context
        }

        let contentHeightAdjustment: CGFloat = preferredAttributes.frame.size.height - originalAttributes.frame.size.height

        let attributes = layoutAttributesForSupplementaryViews[originalAttributesIndex]
        attributes.frame.size.height += contentHeightAdjustment
        attributes.frame.size.width = contentWidth

        context.invalidateSupplementaryElements(ofKind: UICollectionElementKindSectionHeader, at: [attributes.indexPath])

        layoutAttributesForSupplementaryViews[originalAttributesIndex] = attributes

        for layoutAttributesForItem in layoutAttributesForItems {
            if layoutAttributesForItem.indexPath.section < originalAttributes.indexPath.section {
                continue
            }

            layoutAttributesForItem.frame.origin.y += contentHeightAdjustment
            context.invalidateItems(at: [layoutAttributesForItem.indexPath])
        }

        for layoutAttributesForSupplementaryView in layoutAttributesForSupplementaryViews {
            if layoutAttributesForSupplementaryView.indexPath.section <= originalAttributes.indexPath.section {
                continue
            }

            layoutAttributesForSupplementaryView.frame.origin.y += contentHeightAdjustment
            context.invalidateItems(at: [layoutAttributesForSupplementaryView.indexPath])
        }

        contentHeight = layoutAttributesForItems.last?.frame.maxY ?? 0

        return context
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        for layoutAttributes in layoutAttributesForItems where layoutAttributes.indexPath == indexPath {
            return layoutAttributes
        }

        return nil
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        for layoutAttributes in layoutAttributesForSupplementaryViews where layoutAttributes.indexPath == indexPath {
            return layoutAttributes
        }

        return nil
    }

    func initalLayout() {
        layoutAttributesForItems.removeAll()
        layoutAttributesForSupplementaryViews.removeAll()

        guard let collectionView = collectionView,
              let dataSource = collectionView.dataSource else {
            return
        }

        contentHeight = collectionView.contentInset.top

        let numberOfSections = dataSource.numberOfSections?(in: collectionView) ?? 1

        var yOffset: CGFloat = 0

        let readbleWidth = collectionView.readableContentGuide.layoutFrame.width
        let readableContentViewXInset = (collectionView.frame.size.width - readbleWidth - collectionView.contentInset.left - collectionView.contentInset.right) / 2

        let contentViewLayoutMargins = UIEdgeInsets(top: 8, left: readableContentViewXInset, bottom: 8, right: readableContentViewXInset)

        for section in (0..<numberOfSections) {

            if let estimatedHeaderHeight = delegate?.collectionView(collectionView, collectionViewListLayout: self, estimatedHeightForSupplementaryViewFor: section) {
                let frame = CGRect(x: 0, y: yOffset, width: contentWidth, height: estimatedHeaderHeight)
                let insetFrame = frame.insetBy(dx: collectionView.contentInset.left, dy: collectionView.contentInset.right)
                let attributes = CollectionViewListLayoutAttribute(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(row: 0, section: section))
                attributes.frame = insetFrame
                attributes.contentViewLayoutMargins = contentViewLayoutMargins
                attributes.hasAdjustedContentViewLayoutMargins = cellContentViewLayoutMarginsFollowReadableWidth
                layoutAttributesForSupplementaryViews.append(attributes)

                contentHeight = max(contentHeight, frame.maxY)
                yOffset += estimatedHeaderHeight
            }

            for row in (0..<dataSource.collectionView(collectionView, numberOfItemsInSection: section)) {
                let indexPath = IndexPath(row: row, section: section)

                var estimatedHeightForItem: CGFloat
                if let estimatedRowHeight = delegate?.collectionView(collectionView, collectionViewListLayout: self, estimatedHeightForItemAt: indexPath) {
                    estimatedHeightForItem = estimatedRowHeight
                } else {
                    estimatedHeightForItem = estimatedRowHeight
                }

                let frame = CGRect(x: 0, y: yOffset, width: contentWidth, height: estimatedHeightForItem)
                let insetFrame = frame.insetBy(dx: collectionView.contentInset.left, dy: collectionView.contentInset.right)
                let attributes = CollectionViewListLayoutAttribute(forCellWith: indexPath)
                attributes.frame = insetFrame
                attributes.contentViewLayoutMargins = contentViewLayoutMargins
                attributes.hasAdjustedContentViewLayoutMargins = cellContentViewLayoutMarginsFollowReadableWidth
                layoutAttributesForItems.append(attributes)

                contentHeight = max(contentHeight, frame.maxY)
                yOffset += estimatedHeightForItem
            }
        }

        contentHeight += collectionView.contentInset.bottom
    }
}
