//
// Created by john on 08/09/15.
// Copyright (c) 2015 john. All rights reserved.
//

import Foundation
import Cocoa

class NotificationCenterMonitor {

  private let
  userNotificationCenter: NSUserNotificationCenter,
  distributedCenterReceiver: NSDistributedNotificationCenter,
  spotifyRestClient: SpotifyRestClient

  init() {
    self.userNotificationCenter = NSUserNotificationCenter.defaultUserNotificationCenter()
    self.distributedCenterReceiver = NSDistributedNotificationCenter.defaultCenter()
    self.spotifyRestClient = SpotifyRestClient.instance
    registerSelf()
  }

  deinit {
    self.distributedCenterReceiver.removeObserver(self)
  }

  @objc
  func sendUserNotification(notification: NSUserNotification) {
    if let id: String = extractTrackId(notification) {
      self.spotifyRestClient.getTrack(id, successHandler: {
        (track: Track) in
        self.userNotificationCenter.deliverNotification(self.createUserNotification(track))
      })
    }
  }

  private
  func createUserNotification(track: Track) -> NSUserNotification {
    let notification = NSUserNotification()
    notification.title = track.name
    notification.informativeText = "\(track.artistName) - \(track.albumName)"
    notification.contentImage = NSImage(contentsOfURL: NSURL(string: track.albumImageUrl)!)
    notification.hasActionButton = false
    return notification
  }

  private
  func extractTrackId(notification: NSUserNotification) -> String? {
    return notification.userInfo?["Track ID"] as? String
  }

  private
  func registerSelf() {
    self.distributedCenterReceiver.addObserver(self,
                                               selector: "sendUserNotification:",
                                               name: "com.spotify.client.PlaybackStateChanged",
                                               object: nil)
  }
}
