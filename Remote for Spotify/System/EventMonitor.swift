//
//  EventMonitor.swift
//  Remote for Spotify
//
//  Created by john on 06/09/15.
//  Copyright (c) 2015 john. All rights reserved.
//

import Foundation
import Cocoa

public class EventMonitor {
  private var monitor: AnyObject?
  private let mask: NSEventMask
  private let handler: NSEvent? -> ()

  init(mask: NSEventMask, handler: NSEvent? -> ()) {
    self.mask = mask
    self.handler = handler
  }

  deinit {
    stop()
  }

  func start() {
    monitor = NSEvent.addGlobalMonitorForEventsMatchingMask(mask, handler: handler)
  }

  func stop() {
    if monitor != nil {
      NSEvent.removeMonitor(monitor!)
      monitor = nil
    }
  }
}