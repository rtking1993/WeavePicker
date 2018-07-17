// MARK: Frameworks

import Photos

// MARK: WeavePhotoAlbum

class WeavePhotoAlbum: NSObject {
    
    // MARK: Constants
    
    static let albumName = "Weave"
    static let shared = WeavePhotoAlbum()
    
    // MARK: Variables
    
    var assetCollection: PHAssetCollection!
    
    // MARK: Init Methods

    override init() {
        super.init()
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                ()
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func save(image: UIImage?) {
        guard let image = image, assetCollection != nil else {
            // If there was an error upstream, skip the save
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            guard let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset,
                  let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection) else {
                return
            }
            let enumeration: NSArray = [assetPlaceHolder]
            albumChangeRequest.addAssets(enumeration)
            
        }, completionHandler: nil)
    }
    
    // MARK: Helper Methods

    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            // Ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("Trying again to create the album")
            self.createAlbum()
        } else {
            print("Should really prompt the user to let them know it's failed")
        }
    }
    
    func createAlbum() {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: WeavePhotoAlbum.albumName)
        }) { success, error in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            }
        }
    }
    
    func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", WeavePhotoAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }
}
