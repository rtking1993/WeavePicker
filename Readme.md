# WeavePicker

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codebeat badge](https://codebeat.co/badges/d9bae177-78c1-40bb-94a7-187a7759d549)](https://codebeat.co/projects/github-com-rtking1993-weavepicker-master)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

WeavePicker allows the user to select photos from their photo library and then edit the selected photos.

## Features

- 100% Swift
- Localised Strings: English, French, German, Spanish, Portuguese, Italian, Russian, Japanease, Chinese Traditional, Hindi.
- Brightness, Contrast, Exposure, Hue and Saturation editing.
- Album picker option.
- Default filter options.
- Dynamic type supported.
	
<p align="center">
    <img src="https://github.com/rtking1993/WeavePicker/blob/master/IMG_1342.PNG" width="260" alt="All Photos"/>
    <img src="https://github.com/rtking1993/WeavePicker/blob/master/IMG_1341.PNG" width="260" alt="Edit Photos"/>
    <img src="https://github.com/rtking1993/WeavePicker/blob/master/IMG_1343.PNG" width="260" alt="Album Picker"/>
</p>

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

### Using `Image`

```swift
// MARK: Frameworks

import CoreLocation

// MARK: Image

public struct Image {
    
    // MARK: Variables
    
    public var originalImage: UIImage?
    public var finalImage: UIImage?
    public var coordinate: CLLocationCoordinate2D?
    
    public var sampleImage: UIImage? {
        return originalImage?.resized(toWidth: 400)
    }
    
    // MARK: Init Methods
    
    init(originalImage: UIImage?, coordinate: CLLocationCoordinate2D?) {
        self.originalImage = originalImage
        self.finalImage = originalImage
        self.coordinate = coordinate
    }
}
```

## License

WeavePicker is released under the MIT license. [See LICENSE](https://github.com/rtking1993/WeavePicker/edit/master/LICENSE) for details.
