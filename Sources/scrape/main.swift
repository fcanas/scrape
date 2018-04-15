//
//  main.swift
//  Strip
//
//  Created by Fabian Canas on 8/7/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import Foundation
import scrapeLib

/// Argument Parsing

let processInfo = ProcessInfo()

var args: [String] = Array(processInfo.arguments[1..<processInfo.arguments.count])

func printUsage() {
    print("usage: scrape [-p] input_url output_url")
    print("  input_url     a remote URL to an m3u8 HLS playlist")
    print("  output_url    a local path where the HLS stream should be saved")
    print("  -p            download only playlist files")
    print("  -v            verbose output")
}

guard args.count >= 2 else {
    print("At least 2 arguments needed.")
    printUsage()
    exit(EXIT_FAILURE)
}

guard let destinationURL = URL(localOrRemoteString:args.popLast()!) else {
    print("Destination path appears invalid")
    printUsage()
    exit(EXIT_FAILURE)
}

guard let sourceURL = URL(localOrRemoteString:args.popLast()!) else {
    print("Source URL appears invalid")
    printUsage()
    exit(EXIT_FAILURE)
}

enum Option: String {
    case playlistOnly = "-p"
    case verbose = "-v"
}

let group = DispatchGroup()

let downloader = Downloader(destination: destinationURL, group: group)

while let arg = args.popLast() {
    guard let option = Option(rawValue: arg) else {
        print("Unrecognized option: \(arg)")
        printUsage()
        exit(EXIT_FAILURE)
    }
    switch option {
    case .playlistOnly:
        downloader.urlFilter = { url in
            url.fileExtension.hasPrefix("m3u")
        }
    case .verbose:
        verbose = true
    }
}

downloader.downloadHLSResource(sourceURL)

group.wait()

