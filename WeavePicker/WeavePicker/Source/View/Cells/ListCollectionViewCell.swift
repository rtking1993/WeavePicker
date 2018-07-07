// MARK: ListCollectionViewCell

class ListCollectionViewCell: UICollectionViewCell, NibLoadable, ReusableCell {
    
    // MARK: Cell Methods
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let layoutAttributes = layoutAttributes as? CollectionViewListLayoutAttribute, layoutAttributes.hasAdjustedContentViewLayoutMargins {
            layoutIfNeeded()
            
            contentView.layoutMargins = layoutAttributes.contentViewLayoutMargins
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let preferredLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        var fittingSize = UILayoutFittingCompressedSize
        fittingSize.width = preferredLayoutAttributes.size.width
        let size = systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        var adjustedFrame = preferredLayoutAttributes.frame
        adjustedFrame.size.height = ceil(size.height)
        preferredLayoutAttributes.frame = adjustedFrame
        
        return preferredLayoutAttributes
    }
}
