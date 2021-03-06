// MARK: Frameworks

import Photos

// MARK: AssetSession

class AssetSession {
    
    // MARK: Variables
    
    private var cachedAlbums: [Album]?

    // MARK: Helper Methods
    
    func fetchAssets(in album: Album?) -> [PHAsset] {
        var assets = [PHAsset]()
        var fetchedAssets: PHFetchResult<PHAsset>
        
        if let collection = album?.collection {
            fetchedAssets = PHAsset.fetchAssets(in: collection, options: nil)
        } else {
            fetchedAssets = PHAsset.fetchAssets(with: .image, options: nil)
        }
        
        fetchedAssets.enumerateObjects({ (object, _, _) in
            assets.append(object)
        })
        
        return assets
    }
    
    func fetchImageAt(index: Int,
                      in assets: [PHAsset],
                      completion: @escaping(_ image: Image?) -> Void) {
        if assets.count > 0 {
            let asset = assets[index]
            
            // Dispatch the request to the user initiated thread,
            // which is the 2nd priority behind the main thread
            DispatchQueue.global(qos: .userInitiated).async {
                // Make photo request for image
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                options.isNetworkAccessAllowed = true
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: PHImageManagerMaximumSize,
                                                      contentMode: .aspectFill,
                                                      options: options) { (result, _) in
                    DispatchQueue.main.async {
                        completion(Image(index: index,
                                         originalImage: result,
                                         coordinate: asset.location?.coordinate))
                    }
                }
            }
        }
    }
    
    func fetchAlbums(targetSize: CGSize,
                     completion: @escaping(_ albums: [Album]) -> Void) {
        if let cachedAlbums = cachedAlbums {
            completion(cachedAlbums)
            return
        }
        
        var albums = [Album]()
        let options = PHFetchOptions()
        
        let smartAlbumsResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                    subtype: .any,
                                                    options: options)
        let albumsResult = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                   subtype: .any,
                                                                   options: options)
        for result in [smartAlbumsResult, albumsResult] {
            result.enumerateObjects({ assetCollection, _, _ in
                var album = Album()
                album.title = assetCollection.localizedTitle ?? ""
                album.count = self.mediaCount(for: assetCollection)
                if album.count > 0 {
                    let fetchResult = PHAsset.fetchKeyAssets(in: assetCollection, options: nil)
                    if let first = fetchResult?.firstObject {
                        let options = PHImageRequestOptions()
                        options.isSynchronous = true
                        options.deliveryMode = .opportunistic
                        PHImageManager.default().requestImage(for: first,
                                                              targetSize: targetSize,
                                                              contentMode: .aspectFit,
                                                              options: options,
                                                              resultHandler: { image, _ in
                                                                album.thumbnail = image
                        })
                    }
                    album.collection = assetCollection
                    
                    if !(assetCollection.assetCollectionSubtype == .smartAlbumSlomoVideos
                        || assetCollection.assetCollectionSubtype == .smartAlbumVideos) {
                        albums.append(album)
                    }
                }
            })
        }
        cachedAlbums = albums
        completion(albums)
    }
    
    // MARK: Helper Methods
    
    private func mediaCount(for collection: PHAssetCollection) -> Int {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d",
                                        PHAssetMediaType.image.rawValue)
        let result = PHAsset.fetchAssets(in: collection, options: options)
        return result.count
    }
}
