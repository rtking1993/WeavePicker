# WeavePicker

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codebeat badge](https://codebeat.co/badges/d9bae177-78c1-40bb-94a7-187a7759d549)](https://codebeat.co/projects/github-com-rtking1993-weavepicker-master)
![license](https://img.shields.io/rtking1993/WeavePicker/edit/master/LICENSE)

## Requirements

- iOS 11.0+
- Xcode 9.0+
- Swift 4.1+

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate FramesIos into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "rtking1993/WeavePicker"
```

Run `carthage update` to build the framework and drag the built `WeavePicker` into your Xcode project.

## Usage

Import the SDK:

```swift
import WeavePicker
```

### Using `WeavePicker`

```swift
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
        self.present(weavePickerNavigationController, animated: true, completion: nil)
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
```

## License

WeavePicker is released under the MIT license. [See LICENSE](https://github.com/rtking1993/WeavePicker/edit/master/LICENSE) for details.
