//
//  SongInfoViewController.swift
//  Remote for Spotify
//
//  Created by john on 06/09/15.
//  Copyright (c) 2015 john. All rights reserved.
//

import Cocoa

class TrackInfoViewController: NSViewController {

    let spotifyRest: SpotifyRestClient = SpotifyRestClient.instance
    let spotifyLocal: SpotifyLocalClient = SpotifyLocalClient()
    let centerReceiver: NSDistributedNotificationCenter = NSDistributedNotificationCenter.defaultCenter()

    @IBAction func playPause(sender: AnyObject?) {
        spotifyLocal.playPause()
    }

    @IBAction func forward(sender: AnyObject?) {
        spotifyLocal.forward()
    }

    @IBAction func backward(sender: AnyObject?) {
        spotifyLocal.backward()
    }

    @IBAction func toggleShuffle(sender: AnyObject?) {
        spotifyLocal.shuffle((sender as! NSButton).state == NSOnState)
    }

    @IBAction func toggleRepeat(sender: AnyObject?) {
        spotifyLocal.repeat((sender as! NSButton).state == NSOnState)
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        centerReceiver.addObserver(self, selector: "playbackStateChanged:", name: "com.spotify.client.PlaybackStateChanged", object: nil)
        retrievePlayerState()
    }

    override func viewWillDisappear() {
        centerReceiver.removeObserver(self)
        super.viewWillDisappear()
    }

    @objc func playbackStateChanged(notification: NSNotification) {
        retrievePlayerState()
    }

    private func retrievePlayerState() {
        var playerState = spotifyLocal.playerState()
        if let id = playerState.currentTrackId {
            spotifyRest.getTrack(id, sucessHandler: { (track: Track) in self.updateView(playerState, track: track) })
        }
    }

    private func updateView(playerState: PlayerState, track: Track) {
        trackName.stringValue = track.name
        albumName.stringValue = track.albumName
        artistName.stringValue = track.artistName
        albumImage.image = NSImage(contentsOfURL: NSURL(string: track.albumImageUrl)!)
        playPauseButton.state = playerState.isPlaying ? NSOnState : NSOffState
        repeatButton.state = playerState.isRepeating ? NSOnState : NSOffState
        shuffleButton.state = playerState.isShuffling ? NSOnState : NSOffState
    }

    @IBOutlet var trackName: NSTextField!
    @IBOutlet var albumName: NSTextField!
    @IBOutlet var artistName: NSTextField!
    @IBOutlet var albumImage: NSImageView!
    @IBOutlet var playPauseButton: NSButton!
    @IBOutlet var forwardButton: NSButton!
    @IBOutlet var backwardButton: NSButton!
    @IBOutlet var shuffleButton: NSButton!
    @IBOutlet var repeatButton: NSButton!
}
