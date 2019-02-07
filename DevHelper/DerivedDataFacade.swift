//
//  DerivedDataFacade.swift
//  DevHelper
//
//  Created by pavel.grechikhin on 07.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Foundation

protocol DerivedData {
    func fileSize() -> String
}

class DerivedDataFacade: DerivedData {
    
    private let fileManager = FileManager.default
    let derivedPath = "/Users/pavel.grechikhin/Library/Developer/Xcode/DerivedData"
    
    func fileSize() -> String {
        do {
            let size = try fileManager.allocatedSizeOfDirectory(at: URL(string: derivedPath)!)
            let byteFormater = ByteCountFormatter()
            byteFormater.allowedUnits = .useMB
            byteFormater.countStyle = .file
            let prettySize = byteFormater.string(fromByteCount: Int64(size))
            return prettySize
        } catch {
            return "unknown"
        }
    }
}
