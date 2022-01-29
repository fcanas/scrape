//
//  main.swift
//  Strip
//
//  Created by Fabian Canas on 8/7/16.
//  Copyright © 2016 Fabian Canas. All rights reserved.
//

import ArgumentParser
import Foundation
import scrapeLib
import FFCLog

extension String: Error {}

struct Scrape: ParsableCommand {
    
    @Argument
    var sourceURL: String
    
    @Argument(help: "A destination directory that will be the root of the downloaded HLS directory structure and files.")
    var destinationDirectory: String
    
    @Flag(name:.shortAndLong, help: "Downloads only playlist files, no media files.")
    var playlistOnly: Bool = false
    
    @Flag(name:.shortAndLong, help: "Prints verbose diagnostic output to the console.")
    var verbose: Bool = false
    
    func run() throws {
        
        guard
            let sourceURL = URL(localOrRemoteString: sourceURL)
        else {
            throw "Source URL"
        }
        
        guard
            let destinationURL = URL(localOrRemoteString: destinationDirectory)
        else {
            throw "Source URL appears invalid"
        }
        
        let urlFilter: ((URL) -> Bool)?
        
        if playlistOnly {
            urlFilter = { url in
                url.fileExtension.hasPrefix("m3u")
            }
        } else {
            urlFilter = nil
        }
        
        let logLevel: Level = verbose ? .all : .error


        let downloader = Downloader(destination: destinationURL,
                                    ingestFunction: HLS.ingestResource,
                                    logger: FFCLog(thresholdLevel: logLevel))
        urlFilter.map { downloader.urlFilter = $0 }

        downloader.downloadResource(sourceURL)

        downloader.group.wait()
    }
}

Scrape.main()
