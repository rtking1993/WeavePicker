// MARK: EditStepType

enum EditStepType {
    case filter
    case brightness
    case contrast
    case exposure
    case hue
    case saturation
}

// MARK: EditStep

struct EditStep {
    
    // MARK: Variables
    
    var type: EditStepType
    var value: Any
}
