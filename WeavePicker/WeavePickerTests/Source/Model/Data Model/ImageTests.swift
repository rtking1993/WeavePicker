// MARK: Frameworks

import XCTest
import CoreLocation
@testable import WeavePicker

// MARK: ImageTests

class ImageTests: XCTestCase {
    
    // MARK: Variables
    
    var image: Image!
    
    // MARK: Setup Methods
    
    override func setUp() {
        super.setUp()
        
        self.image = setupImage()
    }
    
    // MARK: Helper Methods
    
    private func setupImage() -> Image {
        let parisCoordinate = CLLocationCoordinate2D(latitude: 48.8584,
                                                    longitude: 2.2945)
        return Image(index: 123,
                     originalImage: UIImage(named: "TestImage"),
                     coordinate: parisCoordinate)
    }
    
    // MARK: Test Methods
    
    func testSetup() {
        XCTAssertEqual(image.index, 123)
        XCTAssertEqual(image.originalImage, UIImage(named: "TestImage"))
        XCTAssertEqual(image.finalImage, UIImage(named: "TestImage"))
        XCTAssertEqual(image.sampleImage, UIImage(named: "TestImage"))
        XCTAssertEqual(image.coordinate?.latitude, 48.8584)
        XCTAssertEqual(image.coordinate?.longitude, 2.2945)
    }
}
