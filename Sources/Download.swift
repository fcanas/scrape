//
//  Download.swift
//  Strip
//
//  Created by Fabian Canas on 8/7/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation

class Downloader : NSObject, URLSessionDelegate, URLSessionDownloadDelegate {

    private let group: DispatchGroup

    private lazy var session :URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }()
    
    let destination :URL

    var urlFilter :(URL) -> Bool = { _ in true }
    
    init(destination: URL, group: DispatchGroup) {
        self.destination = destination
        self.group = group
    }
    
    /// Download all resources in a manifest specified at the URL, recursively if a
    /// resource is itself an m3u8 manifest.
    func downloadHLSResource(_ downloadURL: URL) {
        let task = session.downloadTask(with: downloadURL)
        group.enter()
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let resourceURL = downloadTask.currentRequest?.url else {
            return
        }
        ingestHLSResource(resourceURL, temporaryFileURL: location, downloader: self.downloadHLSResource, destinationURL: self.destination, urlFilter: urlFilter)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        diagnostic("\(error != nil ? "failed : \(error!)" : "success") : \(task.originalRequest?.url?.absoluteString ?? "no URL")")
        group.leave()
    }
    
}
