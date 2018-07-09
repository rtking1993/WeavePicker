// MARK: Frameworks

import CoreLocation

// MARK: Image

public struct Image {
    
    // MARK: Variables
    
    public var originalImage: UIImage?
    public var finalImage: UIImage?
    public var coordinate: CLLocationCoordinate2D?
    
    public var sampleImage: UIImage? {
        return originalImage?.resized(toWidth: 400)
    }
    
    // MARK: Init Methods
    
    init(originalImage: UIImage?, coordinate: CLLocationCoordinate2D?) {
        self.originalImage = originalImage
        self.finalImage = originalImage
        self.coordinate = coordinate
    }
}
