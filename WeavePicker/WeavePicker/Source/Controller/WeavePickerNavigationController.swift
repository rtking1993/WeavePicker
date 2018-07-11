// MARK: Frameworks

import UIKit

// MARK: WeavePickerNavigationControllerDelegate

public protocol WeavePickerNavigationControllerDelegate: class {
    func weavePickerNavigationController(_ weavePickerNavigationController: WeavePickerNavigationController, didFinishSelecting images: [Image])
    func weavePickerNavigationControllerDidCancel(_ weavePickerNavigationController: WeavePickerNavigationController)
}

// MARK: WeavePickerNavigationController

public class WeavePickerNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    // MARK: Delegate
    
    public weak var weavePickerDelegate: WeavePickerNavigationControllerDelegate?
    
    public init(startIndex: Int) {
        let imagePickerViewController: ImagePickerViewController = UIStoryboard.instantiateViewController()
        super.init(rootViewController: imagePickerViewController)
        
        imagePickerViewController.delegate = self
        imagePickerViewController.startIndex = startIndex
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}

// MARK: ImagePickerViewControllerDelegate Methods

extension WeavePickerNavigationController: ImagePickerViewControllerDelegate {
    func imagePickerViewControllerDidCancel(_ imagePickerViewController: ImagePickerViewController) {
        weavePickerDelegate?.weavePickerNavigationControllerDidCancel(self)
    }
    
    func imagePickerViewControllerNotAuthorized(_ imagePickerViewController: ImagePickerViewController) {
        let photoPermissionWarning = UIAlertController().photoPermissionWarning()
        present(photoPermissionWarning, animated: true, completion: nil)
    }
}

// MARK: ImageEditViewControllerDelegate Methods

extension WeavePickerNavigationController: ImageEditViewControllerDelegate {
    func imageEditViewController(_ imageEditViewController: ImageEditViewController, didFinishEditing images: [Image]) {
        images.forEach({
            WeavePhotoAlbum.shared.save(image: $0.finalImage)
        })
        
        weavePickerDelegate?.weavePickerNavigationController(self, didFinishSelecting: images)
    }
}
