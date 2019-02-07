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
    func getStringPathToDerivedData() -> String
    func getURLPathToDerivedData() -> URL
}

class DerivedDataFacade: DerivedData {
    
    private let fileManager = FileManager.default
    let derivedPath = "Library/Developer/Xcode/DerivedData"
    
    func fileSize() -> String {
        do {
            let path = getURLPathToDerivedData()
            let size = try fileManager.allocatedSizeOfDirectory(at: path)
            let byteFormater = ByteCountFormatter()
            byteFormater.allowedUnits = .useMB
            byteFormater.countStyle = .file
            let prettySize = byteFormater.string(fromByteCount: Int64(size))
            return prettySize
        } catch {
            return "unknown"
        }
    }
    
    func getStringPathToDerivedData() -> String {
        var path = fileManager.homeDirectoryForCurrentUser.appendingPathComponent(derivedPath, isDirectory: true).absoluteString
        path.removeSubrange(path.range(of: "file://")!)
        return path
//        return fileManager.homeDirectoryForCurrentUser.appendingPathComponent(derivedPath).absoluteString
    }
    
    func getURLPathToDerivedData() -> URL {
//        return fileManager.homeDirectoryForCurrentUser.appendPathComponent(derivedPath, isDirectory: true)
         return fileManager.homeDirectoryForCurrentUser.appendingPathComponent(derivedPath)
    }
}
