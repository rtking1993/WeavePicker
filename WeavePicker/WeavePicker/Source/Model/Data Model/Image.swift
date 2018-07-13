// MARK: Frameworks

import CoreLocation

// MARK: Image

public struct Image: Equatable {
    
    // MARK: Variables
    
    public var index: Int
    public var originalImage: UIImage?
    public var finalImage: UIImage?
    public var coordinate: CLLocationCoordinate2D?
    
    public var sampleImage: UIImage? {
        return originalImage?.resized(toWidth: 400)
    }
    
    // MARK: Init Methods
    
    init(index: Int, originalImage: UIImage?, coordinate: CLLocationCoordinate2D?) {
        self.index = index
        self.originalImage = originalImage
        self.finalImage = originalImage
        self.coordinate = coordinate
    }
    
    // MARK: Equatable Methods
    
    public static func ==(lhs: Image, rhs: Image) -> Bool {
        return lhs.index == rhs.index
    }
}
