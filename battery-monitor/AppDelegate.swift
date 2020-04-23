//
//  AppDelegate.swift
//  battery-monitor
//
//  Created by Hiromasa Ohno on 2020/04/23.
//  Copyright © 2020 SonicGarden. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "Icon")
        }
        
        let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
        statusBarItem.menu = statusBarMenu
        
        statusBarMenu.addItem(
            withTitle: "Preferences",
            action: #selector(AppDelegate.togglePopover),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "Quit",
            action: #selector(AppDelegate.quit),
            keyEquivalent: "")
        
        NSApp.activate(ignoringOtherApps: true)

    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    @objc func quit(_ sender: AnyObject?) {
        NSApplication.shared.terminate(self)
    }
}

