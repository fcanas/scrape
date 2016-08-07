import XCTest
@testable import Strip

class StringExtensionTests: XCTestCase {
    
    func testFullRange() {
        let emptyString :NSString = ""
        let singleCharacter :NSString = "A"
        let multipleLines :NSString = "Something on\nmultiple lines\nis good to test."
        let basic :NSString = "Some basic string"
        
        let allStrings = [emptyString, singleCharacter, multipleLines, basic]
        
        for s in allStrings {
            XCTAssertEqual(s, s.substring(with: s.fullRange))
        }
    }

    func testdeepestDirectoryPath() {
        let f = "/path/with/file"
        XCTAssertEqual(f.deepestDirectoryPath(), "/path/with/")
        
        let d = "/path/without/file/"
        XCTAssertEqual(d.deepestDirectoryPath(), "/path/without/file/")
    }
}


