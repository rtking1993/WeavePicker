// MARK: Filter

public struct Filter {
    let title: String
    let filterType: FilterType
}

// MARK: FilterType

public enum FilterType: String {
    case original = "original"
    case chrome = "CIPhotoEffectChrome"
    case fade = "CIPhotoEffectFade"
    case instant = "CIPhotoEffectInstant"
    case noir = "CIPhotoEffectNoir"
    case process = "CIPhotoEffectProcess"
    case tonal = "CIPhotoEffectTonal"
    case transfer = "CIPhotoEffectTransfer"
    case sepia = "CISepiaTone"
}

public let filters: [Filter] = [
                        Filter(title: NSLocalizedString("Original", comment: ""), filterType: .original),
                        Filter(title: NSLocalizedString("Chrome", comment: ""), filterType: .chrome),
                        Filter(title: NSLocalizedString("Fade", comment: ""), filterType: .fade),
                        Filter(title: NSLocalizedString("Instant", comment: ""), filterType: .instant),
                        Filter(title: NSLocalizedString("Noir", comment: ""), filterType: .noir),
                        Filter(title: NSLocalizedString("Process", comment: ""), filterType: .process),
                        Filter(title: NSLocalizedString("Tonal", comment: ""), filterType: .tonal),
                        Filter(title: NSLocalizedString("Transfer", comment: ""), filterType: .transfer),
                        Filter(title: NSLocalizedString("Sepia", comment: ""), filterType: .sepia)]
