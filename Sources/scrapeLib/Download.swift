//
//  Download.swift
//  Strip
//
//  Created by Fabian Canas on 8/7/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import FFCLog

public class Downloader : NSObject, URLSessionDelegate, URLSessionDownloadDelegate {

    public let group: DispatchGroup

    private lazy var session :URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }()
    
    let destination :URL

    public var urlFilter :(URL) -> Bool = { _ in true }

    let ingester: Ingester
    
    public init(ingester: Ingester, destination: URL, group: DispatchGroup = DispatchGroup()) {
        self.ingester = ingester
        self.destination = destination
        self.group = group
    }
    
    /// Download all resources in a manifest specified at the URL, recursively
    /// if the ingester demands it.
    public func downloadResource(_ downloadURL: URL) {
        let task = session.downloadTask(with: downloadURL)
        group.enter()
        task.resume()
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let resourceURL = downloadTask.currentRequest?.url else {
            return
        }
        ingester.ingest(resource: resourceURL, temporaryFileURL: location, downloader: self.downloadResource, destinationURL: self.destination, urlFilter: urlFilter)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        log("\(error != nil ? "failed : \(error!)" : "success") : \(task.originalRequest?.url?.absoluteString ?? "no URL")")
        group.leave()
    }
    
}
