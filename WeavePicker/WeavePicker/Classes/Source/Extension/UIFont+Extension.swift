// MARK: UIFont Extension

extension UIFont {
    class func autoScalingFont(named fontFamily: String, defaultPointSize pointSize: CGFloat) -> UIFont {
        if #available(iOS 11, *) {
            let font = UIFont(name: fontFamily, size: pointSize)
            return UIFontMetrics.default.scaledFont(for: font!, maximumPointSize: 64.0)
        } else {
            return UIFont(name: fontFamily, size: pointSize)!
        }
    }
}
