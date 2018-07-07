// MARK: AlbumPickerInteractorDelegate

protocol AlbumPickerInteractorDelegate: class {
    func albumPickerInteractor(_ albumPickerInteractor: AlbumPickerInteractor, didObserve albums: [Album])
}

// MARK: AlbumPickerInteractor

class AlbumPickerInteractor {
    
    // MARK: Delegate
    
    weak var delegate: AlbumPickerInteractorDelegate?
    
    // MARK: Variables
    
    let assetSession = AssetSession()

    // MARK: Helper Methods
    
    func observeAlbums() {
        let albums = assetSession.fetchAlbums()
        delegate?.albumPickerInteractor(self, didObserve: albums)
    }
}
