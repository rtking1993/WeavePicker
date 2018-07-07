// MARK: Frameworks

import CoreImage

// MARK: ImageFilterSessionDelegate

protocol ImageFilterSessionDelegate: class {
    func imageFilterSession(_ imageFilterSession: ImageFilterSession, didFinishEditing image: Image?)
    func imageFilterSession(_ imageFilterSession: ImageFilterSession, didUndoEditStep editStep: EditStep)
}

// MARK: ImageFilterSession

class ImageFilterSession {
    
    // MARK: Delegate
    
    weak var delegate: ImageFilterSessionDelegate?
    
    // MARK: Variables
    
    var image: Image?
    var cachedImage: UIImage?
    var editSteps: [EditStep] = [] {
        didSet {
            processEditSteps()
        }
    }

    // MARK: Constants
    
    let context: CIContext!
    let kCIColorControls: String = "CIColorControls"
    let kCIHueAdjust: String = "CIHueAdjust"
    let kCISharpenLuminance: String = "CISharpenLuminance"
    
    // MARK: Init Methods
    
    init() {
        guard let openGLContext = EAGLContext(api: .openGLES2) else {
            fatalError("Could not create OpenGLContext")
        }
        
        self.context = CIContext(eaglContext: openGLContext)
    }
    
    // MARK: Helper Methods

    func removeLastEditStep() {
        if !editSteps.isEmpty {
            let editStep = editSteps.removeLast()
            delegate?.imageFilterSession(self, didUndoEditStep: editStep)
        }
    }
    
    func adjustImage(with type: EditStepType, value: Any) {
        let editStep = EditStep(type: type,
                                value: value)
        appendOrReplace(newEditStep: editStep)
    }
    
    private func appendOrReplace(newEditStep: EditStep) {
        editSteps = editSteps.filter({$0.type != newEditStep.type})
        editSteps.append(newEditStep)
    }
    
    private func processEditSteps() {
        cachedImage = image?.originalImage
        
        editSteps.forEach({
            switch $0.type {
            case .filter:
                if let filterValue = $0.value as? FilterType {
                    cachedImage = adjustWithFilter(filterValue, image: cachedImage)
                }
            case .brightness:
                if let brightnessValue = $0.value as? Float {
                    cachedImage = adjustBrightness(brightnessValue, of: cachedImage)
                }
            case .contrast:
                if let contrastValue = $0.value as? Float {
                    cachedImage = adjustContrast(contrastValue, of: cachedImage)
                }
            case .sharpness:
                if let sharpnessValue = $0.value as? Float {
                        cachedImage = adjustSharpness(sharpnessValue, of: cachedImage)
                }
            case .hue:
                if let hueValue = $0.value as? Float {
                    cachedImage = adjustHue(hueValue, of: cachedImage)
                }
            case .saturation:
                if let saturationValue = $0.value as? Float {
                    cachedImage = adjustSaturation(saturationValue, of: cachedImage)
                }
            }
        })
        
        image?.finalImage = cachedImage
        delegate?.imageFilterSession(self, didFinishEditing: image)
    }
}

// MARK: Image Processing Methods

extension ImageFilterSession {
    private func adjustWithFilter(_ filterType: FilterType, image: UIImage?) -> UIImage? {
        guard let cgImage = image?.cgImage else {
            return image
        }
        
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: filterType.rawValue)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    private func adjustBrightness(_ brightness: Float, of image: UIImage?) -> UIImage? {
        guard let cgImage = image?.cgImage else {
            return image
        }
        
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: kCIColorControls)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(brightness, forKey: kCIInputBrightnessKey)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    private func adjustContrast(_ contrast: Float, of image: UIImage?) -> UIImage? {
        guard let cgImage = image?.cgImage else {
            return image
        }
        
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: kCIColorControls)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(contrast, forKey: kCIInputContrastKey)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    
    private func adjustSharpness(_ sharpness: Float, of image: UIImage?) -> UIImage? {
        guard let cgImage = image?.cgImage else {
            return image
        }
        
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: kCISharpenLuminance)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(sharpness, forKey: kCIInputSharpnessKey)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    private func adjustHue(_ hue: Float, of image: UIImage?) -> UIImage? {
        guard let cgImage = image?.cgImage else {
            return image
        }
        
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: kCIHueAdjust)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(hue, forKey: kCIInputAngleKey)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    private func adjustSaturation(_ saturation: Float, of image: UIImage?) -> UIImage? {
        guard let cgImage = image?.cgImage else {
            return image
        }
        
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: kCIColorControls)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(saturation, forKey: kCIInputSaturationKey)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    private func processFilter(_ filter: CIFilter?, cgImage: CGImage) -> UIImage? {
        guard let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
              let imageResult = context.createCGImage(output, from: output.extent) else {
            return UIImage(cgImage: cgImage)
        }
        
        return UIImage(cgImage: imageResult)
    }
}
