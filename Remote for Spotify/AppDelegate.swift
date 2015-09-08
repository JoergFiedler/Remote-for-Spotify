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
  let centerReceiver: NSDistributedNotificationCenter = NSDistributedNotificationCenter.defaultCenter()
  let userNotificationCenter:NSUserNotificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
  let popover = NSPopover()
  var eventMonitor: EventMonitor?

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

  @objc func sendUserNotification(notification: NSUserNotification) {
    var spotifyRest = SpotifyRestClient.instance
    if let id:String = notification.userInfo?["Track ID"] as? String {
      spotifyRest.getTrack(id, successHandler: {
        (track: Track) in
        var notification = NSUserNotification()
        notification.title = track.name
        notification.informativeText = "\(track.artistName) - \(track.albumName)"
        notification.contentImage = NSImage(contentsOfURL: NSURL(string: track.albumImageUrl)!)
        notification.hasActionButton = false
        self.userNotificationCenter.deliverNotification(notification)
      })
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
    centerReceiver.addObserver(self,
                               selector: "sendUserNotification:",
                               name: "com.spotify.client.PlaybackStateChanged",
                               object: nil)
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    centerReceiver.removeObserver(self)
  }
}
