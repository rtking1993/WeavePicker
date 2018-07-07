// MARK: EditedImage

public struct EditedImage {
    
    // MARK: Variables
    
    public var originalImage: UIImage?
    public var filter: FilterType!

    public var sampleImage: UIImage? {
        return originalImage?.resized(toWidth: 210)
    }
    
    // MARK: Init Methods
    
    init(image: Image) {
        self.originalImage = image.originalImage
    }
}
