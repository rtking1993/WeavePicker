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
    var editSteps: [EditStep] = []

    // MARK: Constants
    
    static let kCIColorControls: String = "CIColorControls"
    static let kCIHueAdjust: String = "CIHueAdjust"
    static let kCISharpenLuminance: String = "CISharpenLuminance"
    let context: CIContext!

    // MARK: Init Methods
    
    init() {
        guard let openGLContext = EAGLContext(api: .openGLES2) else {
            fatalError("Could not create OpenGLContext")
        }
        
        self.context = CIContext(eaglContext: openGLContext)
    }
    
    // MARK: Helper Methods

    func adjustImage(with type: EditStepType, value: Any) {
        let editStep = EditStep(type: type,
                                value: value)
        addStep(newEditStep: editStep)
    }
    
    func removeLastStep() {
        if !editSteps.isEmpty {
            let editStep = editSteps.removeLast()
            delegate?.imageFilterSession(self, didUndoEditStep: editStep)
            processAllEditSteps()
        }
    }
    
    private func addStep(newEditStep: EditStep) {
        if editSteps.contains(where: { $0.type == newEditStep.type }) {
            editSteps = editSteps.filter({$0.type != newEditStep.type})
            editSteps.append(newEditStep)
            processLastEditStep()
        } else {
            editSteps.append(newEditStep)
            processAllEditSteps()
        }
    }
    
    private func processLastEditStep() {
        guard let lastEditStep = editSteps.last else {
            return
        }
        
        let outputImage = self.processEditStep(editStep: lastEditStep)
        image?.finalImage = outputImage
        delegate?.imageFilterSession(self, didFinishEditing: image)
    }
    
    private func processAllEditSteps() {
        cachedImage = image?.originalImage
        
        editSteps.forEach({
            cachedImage = self.processEditStep(editStep: $0)
        })
        
        image?.finalImage = cachedImage
        delegate?.imageFilterSession(self, didFinishEditing: image)
    }
    
    private func processEditStep(editStep: EditStep) -> UIImage? {
        var outputImage: UIImage?
        
        switch editStep.type {
        case .filter:
            if let filterValue = editStep.value as? FilterType {
                outputImage = adjustWithFilter(filterValue, image: cachedImage)
            }
        case .brightness:
            if let brightnessValue = editStep.value as? Float {
                outputImage = adjustBrightness(brightnessValue, of: cachedImage)
            }
        case .contrast:
            if let contrastValue = editStep.value as? Float {
                outputImage = adjustContrast(contrastValue, of: cachedImage)
            }
        case .sharpness:
            if let sharpnessValue = editStep.value as? Float {
                outputImage = adjustSharpness(sharpnessValue, of: cachedImage)
            }
        case .hue:
            if let hueValue = editStep.value as? Float {
                outputImage = adjustHue(hueValue, of: cachedImage)
            }
        case .saturation:
            if let saturationValue = editStep.value as? Float {
                outputImage = adjustSaturation(saturationValue, of: cachedImage)
            }
        }
        
        return outputImage
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
        let filter = CIFilter(name: ImageFilterSession.kCIColorControls)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(brightness, forKey: kCIInputBrightnessKey)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    private func adjustContrast(_ contrast: Float, of image: UIImage?) -> UIImage? {
        guard let cgImage = image?.cgImage else {
            return image
        }
        
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: ImageFilterSession.kCIColorControls)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(contrast, forKey: kCIInputContrastKey)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    
    private func adjustSharpness(_ sharpness: Float, of image: UIImage?) -> UIImage? {
        guard let cgImage = image?.cgImage else {
            return image
        }
        
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: ImageFilterSession.kCISharpenLuminance)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(sharpness, forKey: kCIInputSharpnessKey)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    private func adjustHue(_ hue: Float, of image: UIImage?) -> UIImage? {
        guard let cgImage = image?.cgImage else {
            return image
        }
        
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: ImageFilterSession.kCIHueAdjust)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(hue, forKey: kCIInputAngleKey)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    private func adjustSaturation(_ saturation: Float, of image: UIImage?) -> UIImage? {
        guard let cgImage = image?.cgImage else {
            return image
        }
        
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: ImageFilterSession.kCIColorControls)
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
