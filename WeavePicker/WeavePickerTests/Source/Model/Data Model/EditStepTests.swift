// MARK: Frameworks

import XCTest
@testable import WeavePicker

// MARK: EditStepTests

class EditStepTests: XCTestCase {
    
    // MARK: Test Methods
    
    func testSetupWithAdjustment() {
        let editStep: EditStep = EditStep(type: .brightness,
                                          value: 2.0)
        
        XCTAssertEqual(editStep.type, .brightness)
        XCTAssertEqual(editStep.value as! Double, 2.0)
    }
    
    func testSetupWithFilter() {
        let editStep: EditStep = EditStep(type: .filter,
                                          value: FilterType.instant)
        
        XCTAssertEqual(editStep.type, .filter)
        XCTAssertEqual(editStep.value as! FilterType, .instant)
    }
}
