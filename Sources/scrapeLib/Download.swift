//
//  Download.swift
//  Strip
//
//  Created by Fabian Canas on 8/7/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import FFCLog

public class Downloader: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {

    public let group: DispatchGroup

    private lazy var session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }()

    let destination: URL

    let fileManager: FileManager

    /// A filter indicating whether a URL should be downloaded
    /// Defaults to accepting all URLs
    public var urlFilter: (URL) -> Bool = { _ in true }

    private let ingest: (URL, URL) -> [URL]

    public init(destination: URL,
                ingestFunction: @escaping (URL, URL) -> [URL],
                fileManager: FileManager = FileManager.default,
                group: DispatchGroup = DispatchGroup()) {
        self.destination = destination
        self.fileManager = fileManager
        self.ingest = ingestFunction
        self.group = group
    }

    /// Download the resource at the given URL, recursively if 
    /// `ingestFunction` returns nested URLs
    public func downloadResource(_ downloadURL: URL) {
        let task = session.downloadTask(with: downloadURL)
        group.enter()
        task.resume()
    }

    public func urlSession(_ session: URLSession,
                           downloadTask: URLSessionDownloadTask,
                           didFinishDownloadingTo location: URL) {
        guard let originalResourceURL = downloadTask.currentRequest?.url else {
            return
        }
        // Get embedded URLs for recursive loading
        let newURLs = ingest(originalResourceURL, location)
        let destination = self.destination.appendingPathComponent(originalResourceURL.path, isDirectory: false)
        // Move downloaded resource to final destination
        fileManager.moveFileFrom(location, toURL: destination)
        // Download nested resources
        _ = newURLs.filter(self.urlFilter).map(self.downloadResource)
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let statusString = error.map {"error downloading : \($0)"} ?? "downloaded"
        let urlString = task.originalRequest?.url?.absoluteString ?? "no URL"
        log("\(statusString) : \(urlString)")
        group.leave()
    }

}
