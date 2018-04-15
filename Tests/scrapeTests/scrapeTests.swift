//  Copyright © 2016 Fabian Canas. All rights reserved.

import XCTest
import Foundation
import scrapeLib

class URLExtractionTests: XCTestCase {

    func testURLExtraction() {
        let optURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")
        guard let url = optURL, let manifestString = try? String(contentsOf: url) else {
            XCTFail("URL test stream at \(String(describing: optURL)) failed.")
            return
        }

        let urls = resourceURLs(manifestString as NSString, manifestURL: url).map({$0.absoluteURL})

        let expectedURLs = [
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v5/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v9/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v8/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v7/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v6/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v4/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v3/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v2/prog_index.m3u8",

            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/a1/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/a2/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/a3/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/s1/en/prog_index.m3u8"]
        XCTAssertEqual(Set(urls), Set(expectedURLs.map({URL(string:$0)!})))
    }

}

/*
class StringExtensionTests: XCTestCase {
    
    func testFullRange() {
        let emptyString :NSString = ""
        let singleCharacter :NSString = "A"
        let multipleLines :NSString = "Something on\nmultiple lines\nis good to test."
        let basic :NSString = "Some basic string"
        
        let allStrings = [emptyString, singleCharacter, multipleLines, basic]
        
        for s in allStrings {
            XCTAssertEqual(s as String, s.substring(with: s.fullRange))
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
*/

