// MARK: Framework

import WeavePicker

// MARK: ImageViewController

class ImageViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imagePickerButton: UIButton!

    // MARK: Action Methods
    
    @IBAction func imagePicker(_ sender: Any?) {
        let weavePickerNavigationController: WeavePickerNavigationController = WeavePickerNavigationController(startIndex: 0)
        weavePickerNavigationController.weavePickerDelegate = self
        present(weavePickerNavigationController, animated: true, completion: nil)
    }
}

// MARK: WeavePickerNavigationControllerDelegate Methods

extension ImageViewController: WeavePickerNavigationControllerDelegate {
    func weavePickerNavigationController(_ weavePickerNavigationController: WeavePickerNavigationController, didFinishSelecting images: [Image]) {
        guard let image = images.first else {
            return
        }
        
        imageView.image = image.finalImage
        weavePickerNavigationController.dismiss(animated: true, completion: nil)
    }
    
    func weavePickerNavigationControllerDidCancel(_ weavePickerNavigationController: WeavePickerNavigationController) {
        weavePickerNavigationController.dismiss(animated: true, completion: nil)
    }
}

