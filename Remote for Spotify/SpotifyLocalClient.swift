//
//  SpotifyApplescriptAPI.swift
//  Remote for Spotify
//
//  Created by john on 06/09/15.
//  Copyright (c) 2015 john. All rights reserved.
//

import Foundation

class SpotifyLocalClient {

  let isRunningScript = "tell application \"System Events\" to (name of processes) contains \"Spotify\""

  func playerState() -> PlayerState {
    let isRunning, isPlaying, isRepeating, isShuffling: Bool

    isRunning = isEqual(executeScript(isRunningScript), expect: "true")
    isRepeating = isEqual(executeScript(createScriptForCommand("get repeating")), expect: "true")
    isShuffling = isEqual(executeScript(createScriptForCommand("get shuffling")), expect: "true")
    isPlaying = isEqual(executeScript(createScriptForCommand("get player state")), expect: "kPSP")

    return PlayerState(isRunning: isRunning,
                       isPlaying: isPlaying,
                       isShuffling: isShuffling,
                       isRepeating: isRepeating,
                       currentTrackId: getCurrentTrackId())
  }

  func playPause() {
    executeScript(createScriptForCommand("playpause"))
  }

  func backward() {
    executeScript(createScriptForCommand("previous track"))
  }

  func forward() {
    executeScript(createScriptForCommand("next track"))
  }

  func shuffle(value: Bool) {
    executeScript(createScriptForCommand("set shuffling to \(value)"))
  }

  func repeat(value: Bool) {
    executeScript(createScriptForCommand("set repeating to \(value)"))
  }

  private func getCurrentTrackId() -> String? {
    return executeScript(createScriptForCommand("get id of current track as string"))
  }

  private func executeScript(scriptSource: String) -> String? {
    var error:  NSDictionary?
    let script: NSAppleScript! = NSAppleScript(
    source: scriptSource
    )

    return script?.executeAndReturnError(&error)?.stringValue
  }

  private func createScriptForCommand(command: String) -> String {
    return "tell application \"Spotify\" to \(command)"
  }

  private func isEqual(value: String?, expect: String) -> Bool {
    let result = value?.compare(expect)
    return result == NSComparisonResult.OrderedSame
  }
}