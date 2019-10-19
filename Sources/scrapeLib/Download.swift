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
        return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: opQ)
    }()
    
    let destination :URL

    public var urlFilter :(URL) -> Bool = { _ in true }

    public var ingester: Ingester

    private let sema: DispatchSemaphore

    private let queue: DispatchQueue = DispatchQueue(label: "scrape.download-queue", qos: .background, attributes: [.concurrent], autoreleaseFrequency: .inherit, target: nil)

    private lazy var opQ :OperationQueue =  {
        let o = OperationQueue()
        o.underlyingQueue = self.queue
        return o
    }()
    
    public init(ingester: Ingester, destination: URL, maxTasks: Int = 4, group: DispatchGroup = DispatchGroup()) {
        self.ingester = ingester
        self.destination = destination
        self.group = group

        self.sema = DispatchSemaphore(value: maxTasks)
    }

    var tasks: Set<URLSessionTask> = Set<URLSessionTask>()

    /// Download all resources in a manifest specified at the URL, recursively
    /// if the ingester demands it.
    public func downloadResource(_ downloadURL: URL) {

        queue.async { [weak self] in
            guard let self = self else {
                return
            }
            self.sema.wait()
            let task = self.session.downloadTask(with: downloadURL)
            FFCLog.log("Loading: \(downloadURL)", level: .info)
            task.resume()
            self.tasks.insert(task)
        }
        self.group.enter()

    }

    private let ingestQ = DispatchQueue(label: "ingest-queue", qos: .background, attributes: [.concurrent], autoreleaseFrequency: .inherit, target: nil)
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let resourceURL = downloadTask.currentRequest?.url else {
            return
        }
        ingester.ingest(resource: resourceURL, temporaryFileURL: location, downloader: self.downloadResource, destinationURL: self.destination, urlFilter: urlFilter)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        log("\(error != nil ? "failed : \(error!)" : "success") : \(task.originalRequest?.url?.absoluteString ?? "no URL")")
        sema.signal()
        group.leave()
        self.tasks.remove(task)
    }

    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {

    }

    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {

    }

    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {

    }

    @available(OSX 10.12, *)
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {

    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {

    }

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {

    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

    }

    @available(OSX 10.13, *)
    public func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {

    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {

    }

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

    }

}
