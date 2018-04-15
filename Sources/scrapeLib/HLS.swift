//
//  HLS.swift
//  Strip
//
//  Created by Fabian Canas on 8/1/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import Parsing

// Lines that are neither comments nor tags are URLs to resources - and don't begin with #
let resourceExpression = try! NSRegularExpression(pattern: "^(?!#).+", options: [.anchorsMatchLines])

/// Given an HLS manifest string, and the manifest's URL, generates an array of
/// resource URLs specified in the manifest.
public func resourceURLs(_ manifestString: NSString, manifestURL: URL) -> [URL] {
    let s = manifestString as String

    let master = parseMasterPlaylist(string: s, atURL: manifestURL)
    let renditionURLs = master?.renditions.compactMap({ (rendition) -> URL? in
        rendition.uri
    }) ?? []
    let streamURLs = master?.streams.map({ (stream) -> URL in
        stream.uri
    }) ?? []
    // De-duplicate URLs
    return Array(Set(streamURLs + renditionURLs))
}

let fileManager = FileManager.default

func ingestHLSResource(_ originalResourceURL: URL, temporaryFileURL: URL, downloader: (URL)->Void, destinationURL: URL, urlFilter :(URL)->Bool = { _ in true }) {
    let destination = destinationURL.appendingPathComponent(originalResourceURL.path, isDirectory: false)

    fileManager.moveFileFrom(temporaryFileURL, toURL: destination)

    if originalResourceURL.type == .Playlist {
        let manifestString = try! NSString(contentsOf: destination, encoding: String.Encoding.utf8.rawValue)
        _ = resourceURLs(manifestString, manifestURL: originalResourceURL).filter(urlFilter).map(downloader)
    }
}
