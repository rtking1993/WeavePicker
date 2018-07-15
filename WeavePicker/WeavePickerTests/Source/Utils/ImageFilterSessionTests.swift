// MARK: Frameworks

import XCTest
@testable import WeavePicker

// MARK: ImageFilterTests

class ImageFilterTests: XCTestCase {
    
    // MARK: Variables
    
    var imageFilterSession: ImageFilterSession!
    
    // MARK: Setup Methods
    
    override func setUp() {
        super.setUp()
        
        imageFilterSession = ImageFilterSession()
    }
    
    // MARK: Test Methods
    
    func testSetup() {
        XCTAssertTrue(imageFilterSession.editSteps.isEmpty)
        XCTAssertEqual(imageFilterSession.cachedImage, nil)
        XCTAssertEqual(imageFilterSession.image, nil)
    }
    
    func testAddNewEditStep() {
        XCTAssertTrue(imageFilterSession.editSteps.isEmpty)

        let brightnessStep: EditStep = EditStep(type: .brightness, value: 2.0)
        imageFilterSession.addStep(editStep: brightnessStep)
        
        XCTAssertFalse(imageFilterSession.editSteps.isEmpty)
        XCTAssertEqual(imageFilterSession.editSteps.last!.type, .brightness)
        XCTAssertEqual(imageFilterSession.editSteps.last!.value as! Double, 2.0)
    }
    
    func testAddExistingEditStep() {
        let brightnessStep: EditStep = EditStep(type: .brightness, value: 2.0)
        imageFilterSession.addStep(editStep: brightnessStep)
        
        let contrastStep: EditStep = EditStep(type: .contrast, value: 0.5)
        imageFilterSession.addStep(editStep: contrastStep)
        
        XCTAssertEqual(imageFilterSession.editSteps.count, 2)

        let brightnessStepTwo: EditStep = EditStep(type: .brightness, value: 1.0)
        imageFilterSession.addStep(editStep: brightnessStepTwo)
        
        XCTAssertEqual(imageFilterSession.editSteps.count, 2)
        XCTAssertEqual(imageFilterSession.editSteps.last!.type, .brightness)
        XCTAssertEqual(imageFilterSession.editSteps.last!.value as! Double, 1.0)
    }
    
    func testRemoveLastStep() {
        let brightnessStep: EditStep = EditStep(type: .brightness, value: 2.0)
        imageFilterSession.addStep(editStep: brightnessStep)
        
        let contrastStep: EditStep = EditStep(type: .contrast, value: 0.5)
        imageFilterSession.addStep(editStep: contrastStep)
        
        let hueStep: EditStep = EditStep(type: .hue, value: -2.5)
        imageFilterSession.addStep(editStep: hueStep)
        
        XCTAssertEqual(imageFilterSession.editSteps.count, 3)
        
        imageFilterSession.removeLastStep()
        
        XCTAssertEqual(imageFilterSession.editSteps.count, 2)
        XCTAssertEqual(imageFilterSession.editSteps.last!.type, .contrast)
        XCTAssertEqual(imageFilterSession.editSteps.last!.value as! Double, 0.5)
    }
}
