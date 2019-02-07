//
//  AppDelegate.swift
//  DevHelper
//
//  Created by pavel.grechikhin on 07.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let derivedPath = "/Users/pavel.grechikhin/Library/Developer/Xcode/DerivedData"
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let menu = NSMenu()
    var dataStorage: DataStorageProxy!
    var fileManager = FileManager.default
    lazy var facade: DerivedData = DerivedDataFacade()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        dataStorage = DataStorage()
        if let button = statusItem.button {
            button.image = NSImage(named: "icons8-dev-post-20")
        }
        let lastClearDate = dataStorage.lastClear()
        menu.addItem(withTitle: "Last clear: \(lastClearDate)", action: nil, keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Remove derived data", action: #selector(clearData(sender:)), keyEquivalent: "d")
        let size = self.facade.fileSize()
        menu.addItem(withTitle: "Derived size: \(size)", action: #selector(derivedDataSize(sender:)), keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit", action: #selector(quit(sender:)), keyEquivalent: "q")
        statusItem.menu = menu
    }

    
    func getLastDate() -> String {
        
        return ""
    }
    
}

extension AppDelegate {
    
    @objc func derivedDataSize(sender: NSMenuItem) {
        let size = facade.fileSize()
        let item = menu.item(at: 3)
        item?.title = "Derived size: \(size)"
    }
    
    @objc func clearData(sender: NSMenuItem) {
        
        do {
            try fileManager.removeItem(atPath: derivedPath)
            dataStorage.updateLastDate { (prettyData) in
                let item = menu.item(at: 0)
                item?.title = "Last clear: \(prettyData)"
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func quit(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
}

