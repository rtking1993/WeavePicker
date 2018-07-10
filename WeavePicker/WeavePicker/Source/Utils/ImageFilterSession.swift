// MARK: Frameworks

import CoreImage

// MARK: ImageFilterSessionDelegate

protocol ImageFilterSessionDelegate: class {
    func imageFilterSession(_ imageFilterSession: ImageFilterSession, didFinishEditing image: Image?)
    func imageFilterSession(_ imageFilterSession: ImageFilterSession, didUndo editStep: EditStep)
}

// MARK: ImageFilterSession

class ImageFilterSession {
    
    // MARK: Delegate
    
    weak var delegate: ImageFilterSessionDelegate?
    
    // MARK: Variables
    
    var editSteps: [EditStep] = []
    var cachedImage: UIImage?
    var image: Image?

    // MARK: Constants
    
    static let kCIColorControls: String = "CIColorControls"
    static let kCIHueAdjust: String = "CIHueAdjust"
    static let kCISharpenLuminance: String = "CISharpenLuminance"
    static let kCIExposureAdjust: String = "CIExposureAdjust"
    static let kInputEV: String = "inputEV"
    let context: CIContext!

    // MARK: Init Methods
    
    init() {
        guard let openGLContext = EAGLContext(api: .openGLES2) else {
            fatalError("Could not create OpenGLContext")
        }
        
        self.context = CIContext(eaglContext: openGLContext)
    }
    
    // MARK: Helper Methods

    func addStep(newEditStep: EditStep) {
        if editSteps.contains(where: { $0.type == newEditStep.type }) {
            editSteps = editSteps.filter({$0.type != newEditStep.type})
            editSteps.append(newEditStep)
            processLastEditStep()
        } else {
            editSteps.append(newEditStep)
            processAllEditSteps()
        }
    }
    
    func removeLastStep() {
        if !editSteps.isEmpty {
            let editStep = editSteps.removeLast()
            processAllEditSteps()
            delegate?.imageFilterSession(self, didUndo: editStep)
        }
    }
    
    private func processLastEditStep() {
        if let lastEditStep = editSteps.last {
            image?.finalImage = self.processEditStep(editStep: lastEditStep,
                                                     on: cachedImage)
            delegate?.imageFilterSession(self, didFinishEditing: image)
        }
    }
    
    private func processAllEditSteps() {
        var outputImage = image?.originalImage
        
        editSteps.forEach({
            outputImage = self.processEditStep(editStep: $0,
                                               on: outputImage)
        })
        
        cachedImage = outputImage
        image?.finalImage = outputImage
        delegate?.imageFilterSession(self, didFinishEditing: image)
    }
    
    private func processEditStep(editStep: EditStep,
                                 on inputImage: UIImage?) -> UIImage? {
        var outputImage: UIImage?
        
        switch editStep.type {
        case .filter:
            if let filterValue = editStep.value as? FilterType,
               let cgCachedImage = inputImage?.cgImage {
                outputImage = adjustFilter(of: cgCachedImage,
                                           filterType: filterValue)
            }
        case .brightness:
            if let brightnessValue = editStep.value as? Float,
               let cgCachedImage = inputImage?.cgImage {
                outputImage = adjustColorControls(of: cgCachedImage,
                                                  with: kCIInputBrightnessKey,
                                                  to: brightnessValue)
            }
        case .contrast:
            if let contrastValue = editStep.value as? Float,
               let cgCachedImage = inputImage?.cgImage {
                outputImage = adjustColorControls(of: cgCachedImage,
                                                  with: kCIInputContrastKey,
                                                  to: contrastValue)
            }
        case .exposure:
            if let sharpnessValue = editStep.value as? Float,
               let cgCachedImage = inputImage?.cgImage {
                outputImage = adjustExposure(of: cgCachedImage,
                                             to: sharpnessValue)
            }
        case .hue:
            if let hueValue = editStep.value as? Float,
               let cgCachedImage = inputImage?.cgImage {
                outputImage = adjustHue(of: cgCachedImage,
                                        to: hueValue)
            }
        case .saturation:
            if let saturationValue = editStep.value as? Float,
               let cgCachedImage = inputImage?.cgImage {
                outputImage = adjustColorControls(of: cgCachedImage,
                                                  with: kCIInputSaturationKey,
                                                  to: saturationValue)
            }
        }
        
        return outputImage
    }
}

// MARK: Image Processing Methods

extension ImageFilterSession {
    
    // MARK: Filter Methods

    private func adjustFilter(of cgImage: CGImage,
                              filterType: FilterType) -> UIImage? {
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: filterType.rawValue)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    private func adjustColorControls(of cgImage: CGImage,
                                     with key: String,
                                     to value: Float) -> UIImage? {
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: ImageFilterSession.kCIColorControls)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(value, forKey: key)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    private func adjustExposure(of cgImage: CGImage,
                                to exposure: Float) -> UIImage? {
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: ImageFilterSession.kCIExposureAdjust)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(exposure, forKey: ImageFilterSession.kInputEV)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    private func adjustHue(of cgImage: CGImage,
                           to hue: Float) -> UIImage? {
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: ImageFilterSession.kCIHueAdjust)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(hue, forKey: kCIInputAngleKey)
        
        return processFilter(filter, cgImage: cgImage)
    }
    
    // MARK: Helper Methods
    
    private func processFilter(_ filter: CIFilter?, cgImage: CGImage) -> UIImage? {
        guard let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
              let imageResult = self.context.createCGImage(output, from: output.extent) else {
            return UIImage(cgImage: cgImage)
        }
        
        return UIImage(cgImage: imageResult)
    }
}
