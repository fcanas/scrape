//  Copyright © 2016 Fabian Canas. All rights reserved.

import XCTest
import Foundation
@testable import scrapeLib

class URLExtractionTests: XCTestCase {

    func testMasterPlaylistURLExtraction() {
        let optURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")
        guard let url = optURL, let manifestString = try? String(contentsOf: url) else {
            XCTFail("URL test stream at \(String(describing: optURL)) failed.")
            return
        }

        let urls = HLS.resourceURLs(manifestString as NSString, manifestURL: url).map({$0.absoluteURL})

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

    func testMasterPlaylistURLExtractionWithExternalCaptions() {
        let optURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")

        guard let url = optURL, let manifestString = try? String(contentsOf: url) else {
            XCTFail("URL test stream at \(String(describing: optURL)) failed.")
            return
        }

        let urls = HLS.resourceURLs(manifestString as NSString, manifestURL: url).map({$0.absoluteURL})

        let expectedURLs = [
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v3/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/s1/en/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v5/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v6/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v9/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/a2/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v7/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v2/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v8/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/a1/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/a3/prog_index.m3u8",
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v4/prog_index.m3u8"
        ]

        XCTAssertEqual(Set(urls), Set(expectedURLs.map({URL(string:$0)!})))
    }

    func testSubtitlePlaylistExtraction() {
        let optURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/s1/en/prog_index.m3u8")

        guard let url = optURL, let manifestString = try? String(contentsOf: url) else {
            XCTFail("URL test stream at \(String(describing: optURL)) failed.")
            return
        }

        let urls = HLS.resourceURLs(manifestString as NSString, manifestURL: url).map({$0.absoluteURL})

        let expectedURLs = (0...99).map { URL(string:"https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/s1/en/fileSequence\($0).webvtt")! }

        XCTAssertEqual(Set(urls).symmetricDifference(Set(expectedURLs)), Set())
    }

    func testMediaPlaylistURLExtraction() {
        let optURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v2/prog_index.m3u8")
        guard let url = optURL, let manifestString = try? String(contentsOf: url) else {
            XCTFail("URL test stream at \(String(describing: optURL)) failed.")
            return
        }

        let urls = HLS.resourceURLs(manifestString as NSString, manifestURL: url).map({$0.absoluteURL})

        let expectedURLs = [
            "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/v2/main.mp4"]
        XCTAssertEqual(Set(urls), Set(expectedURLs.map({URL(string:$0)!})))
    }

    func testMediaPlaylistSubtitleURLExtraction() {
        let optURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/s1/en/prog_index.m3u8")
        guard let url = optURL, let manifestString = try? String(contentsOf: url) else {
            XCTFail("URL test stream at \(String(describing: optURL)) failed.")
            return
        }

        let urls = Set(HLS.resourceURLs(manifestString as NSString, manifestURL: url).map({$0.absoluteURL}))

        XCTAssertEqual(urls.count, 100)
        for i in 0...99 {
            XCTAssertTrue(urls.contains(URL(string:"https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/s1/en/fileSequence\(i).webvtt")!))
        }
    }

}
