//
//  Ingest.swift
//  FFCLog
//
//  Created by Fabian Canas on 7/8/18.
//  Copyright © 2018 Fabian Canas. All rights reserved.
//

import Foundation

public protocol Ingester {
    func ingest(resource originalResourceURL: URL, temporaryFileURL: URL, downloader: (URL)->Void, destinationURL: URL, urlFilter :(URL)->Bool)
}
