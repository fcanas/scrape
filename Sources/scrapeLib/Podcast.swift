//
//  Podcast.swift
//  scrapeLib
//
//  Created by Fabian Canas on 7/8/18.
//  Copyright © 2018 Fabian Canas. All rights reserved.
//

import Foundation

public class PodcastIngester: NSObject, Ingester {

    override public init() { super.init() }

    let fileManager = FileManager.default

    var downloader: (URL)->Void = { _ in }

    public func ingest(resource originalResourceURL: URL, temporaryFileURL: URL, downloader: @escaping (URL)->Void, destinationURL: URL, urlFilter :(URL)->Bool = { _ in true }) {
        let destination = destinationURL.appendingPathComponent(originalResourceURL.path, isDirectory: false)

        fileManager.moveFileFrom(temporaryFileURL, toURL: destination)

        if originalResourceURL.absoluteString.suffix(3) == "rss", let data = try? Data(contentsOf: destination) {
            self.downloader = downloader
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
    }
}

extension PodcastIngester: XMLParserDelegate {
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        guard elementName == "enclosure", let urlAttribute = attributeDict["url"] else {
            return
        }

        if let url = URL(string: urlAttribute) {
            self.downloader(url)
        }
    }
}

