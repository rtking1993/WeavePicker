// MARK: Frameworks

import Photos

// MARK: AlbumViewModel

struct AlbumViewModel {
    
    // MARK: Variables
    
    var thumbnail: UIImage?
    var title: String = ""
    var count: String = "0"
    
    // MARK: Init Methods
    
    init(album: Album) {
        self.thumbnail = album.thumbnail
        self.title = album.title
        self.count = String(describing: album.count)
    }
}
