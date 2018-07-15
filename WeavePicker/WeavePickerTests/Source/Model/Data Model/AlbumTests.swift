// MARK: Frameworks

import XCTest
@testable import WeavePicker

// MARK: AlbumTests

class AlbumTests: XCTestCase {
    
    // MARK: Variables
    
    var album: Album!
    
    // MARK: Setup Methods
    
    override func setUp() {
        super.setUp()
        
        self.album = setupAlbum()
    }
    
    // MARK: Helper Methods
    
    private func setupAlbum() -> Album {
        return Album(thumbnail: UIImage(named: "TestImage"),
                     title: "Favourites",
                    count: 42,
                     collection: nil)
    }
    
    // MARK: Test Methods
    
    func testSetup() {
        XCTAssertEqual(album.thumbnail, UIImage(named: "TestImage"))
        XCTAssertEqual(album.title, "Favourites")
        XCTAssertEqual(album.count, 42)
    }
}
