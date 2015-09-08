//
//  AppDelegate.swift
//  Remote for Spotify
//
//  Created by john on 06/09/15.
//  Copyright (c) 2015 john. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
  let notificationCenterMonitor: NotificationCenterMonitor
  let popover = NSPopover()
  var eventMonitor: EventMonitor?

  override init() {
    self.notificationCenterMonitor = NotificationCenterMonitor()
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

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    if let button = statusItem.button {
      button.image = NSImage(named: "StatusBarButtonImage")
      button.action = Selector("togglePopover:")
    }

    popover.contentViewController = TrackInfoViewController(nibName: "TrackInfoView", bundle: nil)
    eventMonitor = EventMonitor(
    mask: NSEventMask.LeftMouseDownMask | NSEventMask.RightMouseDownMask | NSEventMask.KeyDownMask,
    handler: { (event) -> () in self.closePopover(event!) })
  }

  func applicationWillTerminate(aNotification: NSNotification) {
  }
}
