//
//  AppDelegate.swift
//  Remote for Spotify
//
//  Created by john on 06/09/15.
//  Copyright (c) 2015 john. All rights reserved.
//

import Cocoa
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
  let notificationCenterMonitor: NotificationCenterMonitor
  let popover: NSPopover = NSPopover()
  let controller:TrackInfoViewController?
  var eventMonitor: EventMonitor?

  override init() {
    self.notificationCenterMonitor = NotificationCenterMonitor()
    self.controller = TrackInfoViewController(nibName: "TrackInfoView", bundle: nil)!
  }

  func closePopover(sender: AnyObject) {
    eventMonitor?.stop()
    popover.close()
  }

  func openPopover(sender: AnyObject) {
    if let button = statusItem.button {
      popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSMinYEdge)
      eventMonitor?.start()
    }
  }

  func togglePopover(sender: AnyObject) {
    if popover.shown {
      closePopover(sender)
    } else {
      openPopover(sender)
    }
  }
    
    func help(sender:AnyObject?) {
        println(sender)
    }

  func createMenu(controller: NSViewController) {
    let menu = NSMenu()

    let item: NSMenuItem = NSMenuItem(title: "Print Quote",
                                      action:Selector("help:"),
                                      keyEquivalent: "P")
    item.view = controller.view
    menu.addItem(item)
    statusItem.menu = menu
  }

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    if let button = statusItem.button {
      button.image = NSImage(named: "StatusBarButtonImage")
    }

    
    createMenu(self.controller!)
    eventMonitor = EventMonitor(mask: NSEventMask.LeftMouseDownMask | NSEventMask.RightMouseDownMask,
                                handler: { (event) -> () in self.closePopover(event!) })
  }

  func applicationWillTerminate(aNotification: NSNotification) {
  }
}
