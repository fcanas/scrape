//
//  File.swift
//  Strip
//
//  Created by Fabian Canas on 8/1/16.
//
//

import Foundation

extension FileManager {
    func moveFileFrom(_ fromURL: URL, toURL destination: URL) {
        
        if !fileExists(atPath: destination.path.deepestDirectoryPath()) {
            // target directory does not exist. create it.
            do {
                try self.createDirectory(at: destination.directoryURL(), withIntermediateDirectories: true, attributes: [:])
            } catch {
                print("error creating intermediate directories")
            }
        }
        
        do {
            try self.moveItem(at: fromURL, to: destination)
        } catch let e as NSError {
            do {
                try self.replaceItem(at: destination, withItemAt: fromURL, backupItemName: nil, options: FileManager.ItemReplacementOptions(), resultingItemURL: nil)
            } catch let er as NSError {
                print("bail: \(er)")
                return
            }
            print("problem moving file \(e)")
        }
    }
}


