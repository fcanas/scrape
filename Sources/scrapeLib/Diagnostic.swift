//
//  Diagnostic.swift
//  scrapeLib
//
//  Created by Fabian Canas on 4/14/18.
//

import Foundation

public var verbose: Bool = false

func diagnostic(_ string: String) {
    if verbose {
        print(string)
    }
}
