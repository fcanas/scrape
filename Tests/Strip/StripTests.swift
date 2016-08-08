//  Copyright © 2016 Fabian Canas. All rights reserved.

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

class URLExtensionTests: XCTestCase {
    
    func testDetectSegment() {
        let segment = URL(string: "http://example.com/hls/stream/segment01.ts")
        let query = URL(string: "http://example.com/hls/stream/segment01.ts?q=thing")
        let fragment = URL(string: "http://example.com/hls/stream/segment01.ts#fragment")
        
        XCTAssertEqual(segment?.type, .Media)
        XCTAssertEqual(query?.type, .Media)
        XCTAssertEqual(fragment?.type, .Media)
    }
    
    func testDetectPlaylist() {
        let segment = URL(string: "http://example.com/hls/stream/segment01.m3u8")
        let query = URL(string: "http://example.com/hls/stream/segment01.m3u8?q=thing")
        let fragment = URL(string: "http://example.com/hls/stream/segment01.m3u8#fragment")
        
        XCTAssertEqual(segment?.type, .Playlist)
        XCTAssertEqual(query?.type, .Playlist)
        XCTAssertEqual(fragment?.type, .Playlist)
    }
    
    func testIgnoreNonHLSTypes() {
        let nonSegment = URL(string: "http://example.com/hls/stream/segment01.mp3")
        let query = URL(string: "http://example.com/hls/stream/segment01.aac?q=thing")
        let fragment = URL(string: "http://example.com/hls/stream/segment01.tts#fragment")
        
        XCTAssertEqual(nonSegment?.type, .Media)
        XCTAssertEqual(query?.type, .Media)
        XCTAssertEqual(fragment?.type, .Media)
    }
    
}


