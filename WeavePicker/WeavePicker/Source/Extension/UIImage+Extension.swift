// MARK: Frameworks

import CoreImage

// MARK: UIImage Extension

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let scale = size.width / size.height
        let canvasSize = CGSize(width: width, height: ceil(width * scale))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func adjustImage(with filterType: FilterType) -> UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }
        
        let context = CIContext()
        let coreImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: filterType.rawValue)
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        
        guard let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage,
              let imageResult = context.createCGImage(output, from: output.extent) else {
            return self
        }
        
        return UIImage(cgImage: imageResult)
    }
}
