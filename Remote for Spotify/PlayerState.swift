//
//  PlayerState.swift
//  Remote for Spotify
//
//  Created by john on 07/09/15.
//  Copyright (c) 2015 john. All rights reserved.
//

import Foundation

struct PlayerState {
  var isRunning:      Bool
  var isPlaying:      Bool
  var isShuffling:    Bool
  var isRepeating:    Bool
  var currentTrackId: String?
}