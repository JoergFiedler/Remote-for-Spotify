//
//  SpotifyRestClient.swift
//  Remote for Spotify
//
//  Created by john on 06/09/15.
//  Copyright (c) 2015 john. All rights reserved.
//

import Foundation

class SpotifyRestClient {

  static let instance: SpotifyRestClient = SpotifyRestClient()
  let session: NSURLSession!

  private init() {
    session = NSURLSession.sharedSession()
  }

  func getTrack(spotifyId: String, successHandler: (Track) -> Void) {
    let id = spotifyId.componentsSeparatedByString(":")[2]
    httpGet(id, successHandler: successHandler)
  }

  private func httpGet(id: String, successHandler: (Track) -> Void) {
    let url: NSURL = NSURL(string: "https://api.spotify.com/v1/tracks/\(id)")!
    let task: NSURLSessionDataTask = session.dataTaskWithURL(url, completionHandler: {
      (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
      let trackAsJson = JSON(data: data!)
      successHandler(Track(name: trackAsJson["name"].string ?? "",
                           albumName: trackAsJson["album"]["name"].string ?? "",
                           artistName: trackAsJson["artists"][0]["name"].string ?? "",
                           albumImageUrl: trackAsJson["album"]["images"][0]["url"].string ?? ""))
    })

    task.resume()
  }
}
