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
        let size = self.facade.fileSize()
        menu.addItem(withTitle: "Derived size: \(size)", action: nil, keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Remove derived data", action: #selector(clearData(sender:)), keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit", action: #selector(quit(sender:)), keyEquivalent: "q")
        menu.delegate = self
        statusItem.menu = menu
    }
}

extension AppDelegate {
    
    @objc func derivedDataSize(sender: NSMenuItem) {
        updateMenu()
    }
    
    @objc func clearData(sender: NSMenuItem) {
        do {
            var path = facade.getStringPathToDerivedData()
            path.removeLast()
            try fileManager.removeItem(atPath: path)
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
    
    func updateMenu() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            print("start update")
            guard let strongSelf = self else { return }
            let size = strongSelf.facade.fileSize()
            let item = strongSelf.menu.item(at: 1)
            DispatchQueue.main.async {
                item?.title = "Derived size: \(size)"
                print("finish update")
            }
        }
    }
    
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        updateMenu()
    }
}
