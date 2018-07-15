// MARK: Frameworks

import XCTest
@testable import WeavePicker

// MARK: AlbumViewModelTests

class AlbumViewModelTests: XCTestCase {
    
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
        let albumViewModel: AlbumViewModel = AlbumViewModel(album: album)
    
        XCTAssertEqual(albumViewModel.thumbnail, UIImage(named: "TestImage"))
        XCTAssertEqual(albumViewModel.title, "Favourites")
        XCTAssertEqual(albumViewModel.count, "42")
    }
}
