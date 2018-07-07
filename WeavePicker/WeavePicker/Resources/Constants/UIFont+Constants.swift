// MARK: UIFont Constants

extension UIFont {
    static let compactHeader: UIFont = UIFont(name: "Avenir-Heavy", size: 32)!
    static let compactSubheader: UIFont = UIFont(name: "Avenir-Medium", size: 24)!
    static let compactAction: UIFont = UIFont(name: "Avenir-Roman", size: 18)!
    static let compactBody: UIFont = UIFont(name: "Avenir-Book", size: 14)!
    static let boldCompactBody: UIFont = UIFont(name: "Avenir-Medium", size: 14)!
    static let compactCaption: UIFont = UIFont(name: "Avenir-Light", size: 12)!
    static let boldCompactCaption: UIFont = UIFont(name: "Avenir-Medium", size: 12)!

    static let header: UIFont = UIFont(name: "Avenir-Heavy", size: 64)!
    static let subheader: UIFont = UIFont(name: "Avenir-Medium", size: 48)!
    static let action: UIFont = UIFont(name: "Avenir-Roman", size: 36)!
    static let body: UIFont = UIFont(name: "Avenir-Book", size: 28)!
    static let boldBody: UIFont = UIFont(name: "Avenir-Medium", size: 28)!
    static let caption: UIFont = UIFont(name: "Avenir-Light", size: 24)!
    static let boldCaption: UIFont = UIFont(name: "Avenir-Medium", size: 24)!

    static var headerScaled: UIFont {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular &&
           UIScreen.main.traitCollection.verticalSizeClass == .regular {
            return UIFontMetrics.default.scaledFont(for: .header, maximumPointSize: 128)
        } else {
            return UIFontMetrics.default.scaledFont(for: .compactHeader, maximumPointSize: 64)
        }
    }
    
    static var subheaderScaled: UIFont {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular &&
            UIScreen.main.traitCollection.verticalSizeClass == .regular {
            return UIFontMetrics.default.scaledFont(for: .subheader, maximumPointSize: 96)
        } else {
            return UIFontMetrics.default.scaledFont(for: .compactSubheader, maximumPointSize: 48)
        }
    }
    
    static var actionScaled: UIFont {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular &&
            UIScreen.main.traitCollection.verticalSizeClass == .regular {
            return UIFontMetrics.default.scaledFont(for: .action, maximumPointSize: 72)
        } else {
            return UIFontMetrics.default.scaledFont(for: .compactAction, maximumPointSize: 36)
        }
    }
    
    static var bodyScaled: UIFont {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular &&
            UIScreen.main.traitCollection.verticalSizeClass == .regular {
            return UIFontMetrics.default.scaledFont(for: .body, maximumPointSize: 56)
        } else {
            return UIFontMetrics.default.scaledFont(for: .compactBody, maximumPointSize: 28)
        }
    }
    
    static var boldBodyScaled: UIFont {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular &&
            UIScreen.main.traitCollection.verticalSizeClass == .regular {
            return UIFontMetrics.default.scaledFont(for: .boldBody, maximumPointSize: 56)
        } else {
            return UIFontMetrics.default.scaledFont(for: .boldCompactBody, maximumPointSize: 28)
        }
    }

    static var captionScaled: UIFont {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular &&
            UIScreen.main.traitCollection.verticalSizeClass == .regular {
            return UIFontMetrics.default.scaledFont(for: .caption, maximumPointSize: 48)
        } else {
            return UIFontMetrics.default.scaledFont(for: .compactCaption, maximumPointSize: 24)
        }
    }
    
    static var boldCaptionScaled: UIFont {
        if UIScreen.main.traitCollection.horizontalSizeClass == .regular &&
            UIScreen.main.traitCollection.verticalSizeClass == .regular {
            return UIFontMetrics.default.scaledFont(for: .boldCaption, maximumPointSize: 48)
        } else {
            return UIFontMetrics.default.scaledFont(for: .boldCompactBody, maximumPointSize: 24)
        }
    }
}
