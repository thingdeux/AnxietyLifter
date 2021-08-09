    import XCTest
    @testable import AnxietyLifterCore

    @available(iOS 13.0.0, *)
    final class AnxietyLifterCoreTests: XCTestCase {
        func testCautionLevelAssessmentLow() {
            let valueToAssess = CautionLevel.go.rawValue + CautionLevel.caution.rawValue + CautionLevel.caution.rawValue
            XCTAssertEqual(AlertStateData.determineRawThreshold(valueToAssess), CautionLevel.go)
        }
        
        func testCautionLevelAssessmentAnyHighSkewsHardImmediateCaution() {
            // Make sure that a high from one area immediately skews very hard and any other non green light skews yellow.
            let valueToAssess = CautionLevel.go.rawValue + CautionLevel.caution.rawValue + CautionLevel.stop.rawValue
            XCTAssertEqual(AlertStateData.determineRawThreshold(valueToAssess), CautionLevel.caution)
        }
        
        func testCautionLevelAssessmentMedium() {
            let valueToAssess = CautionLevel.caution.rawValue + CautionLevel.caution.rawValue + CautionLevel.stop.rawValue
            XCTAssertEqual(AlertStateData.determineRawThreshold(valueToAssess), CautionLevel.caution)
        }
        
        func testCautionLevelAssessmentHigh() {
            let valueToAssess = CautionLevel.stop.rawValue + CautionLevel.caution.rawValue + CautionLevel.stop.rawValue
            XCTAssertEqual(AlertStateData.determineRawThreshold(valueToAssess), CautionLevel.stop)
        }
        
        func testCautionLevelAssessmentUltra() {
            let valueToAssess = CautionLevel.stop.rawValue + CautionLevel.stop.rawValue + CautionLevel.stop.rawValue
            XCTAssertEqual(AlertStateData.determineRawThreshold(valueToAssess), CautionLevel.stop)
        }
        
    }
