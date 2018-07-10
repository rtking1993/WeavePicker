// MARK: Frameworks

import Photos

// MARK: Frameworks

class WeavePhotoAlbum {
    
    // MARK: Constants
    
    static let albumName = "Weave"
    static let sharedInstance = WeavePhotoAlbum()
    
    // MARK: Variables
    
    var assetCollection: PHAssetCollection!
    
    // MARK: Init Methods
    
    init() {
        func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", WeavePhotoAlbum.albumName)
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            
            if let firstObject: AnyObject = collection.firstObject {
                return collection.firstObject as! PHAssetCollection
            }
            
            return nil
        }
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: WeavePhotoAlbum.albumName)
        }) { success, _ in
            if success {
                self.assetCollection = fetchAssetCollectionForAlbum()
            }
        }
    }
    
    func saveImage(image: UIImage) {
        if assetCollection == nil {
            return   // If there was an error upstream, skip the save.
        }
        
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            guard let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset,
                  let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) else {
                return
            }
            albumChangeRequest.addAssets(NSArray(array: [assetPlaceholder]))
        }, completionHandler: nil)
    }
}
