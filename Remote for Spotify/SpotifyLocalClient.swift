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

  func retrievePlayerState() -> PlayerState {
    let isRunning, isPlaying, isRepeating, isShuffling: Bool

    isRunning = isEqual(runScript(isRunningScript), to: "true")
    isRepeating = isEqual(executeCommand("get repeating"), to: "true")
    isShuffling = isEqual(executeCommand("get shuffling"), to: "true")
    isPlaying = isEqual(executeCommand("get player state"), to: "kPSP")

    return PlayerState(isRunning: isRunning,
                       isPlaying: isPlaying,
                       isShuffling: isShuffling,
                       isRepeating: isRepeating,
                       currentTrackId: getIdOfCurrentTrack())
  }

  func playPause() {
    executeCommand("playpause")
  }

  func backward() {
    executeCommand("previous track")
  }

  func forward() {
    executeCommand("next track")
  }

  func shuffle(value: Bool) {
    executeCommand("set shuffling to \(value)")
  }

  func repeat(value: Bool) {
    executeCommand("set repeating to \(value)")
  }

  private func getIdOfCurrentTrack() -> String? {
    return executeCommand("get id of current track as string")
  }

  private func executeCommand(command: String) -> String? {
    return runScript(createScriptFor(command))
  }

  private func runScript(source: String) -> String? {
    var error: NSDictionary?
    let script: NSAppleScript! = NSAppleScript(source: source)

    return script?.executeAndReturnError(&error)?.stringValue
  }

  private func createScriptFor(command: String) -> String {
    return "tell application \"Spotify\" to \(command)"
  }

  private func isEqual(value: String?, to: String) -> Bool {
    let result = value?.compare(to)
    return result == NSComparisonResult.OrderedSame
  }
}