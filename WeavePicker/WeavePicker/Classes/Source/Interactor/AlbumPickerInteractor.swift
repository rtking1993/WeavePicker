// MARK: AlbumPickerInteractor

class AlbumPickerInteractor {
    
    // MARK: Variables
    
    let assetSession = AssetSession()

    // MARK: Helper Methods
    
    func observeAlbums(completion: @escaping(_ albums: [Album]) -> Void) {
        let targetSize :CGSize = CGSize(width: UIScreen.main.scale * 74,
                                        height: UIScreen.main.scale * 74)
        assetSession.fetchAlbums(targetSize: targetSize,
                                 completion: completion)
    }
}
