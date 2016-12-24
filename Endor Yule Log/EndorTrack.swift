//
//  EndorTrack.swift
//  Endor Yule Log
//
//  Created by Mike Drum on 12/24/16.
//
//

import Foundation
import AVFoundation

enum TrackType: Int {
  case video,
  crackling
}

class EndorTrack {
  var type: TrackType
  var isMuted: Bool
  var asset: AVURLAsset
  var trackID: CMPersistentTrackID
  
  init(type: TrackType, muted: Bool) {
    self.type = type
    self.isMuted = muted
    
    switch type {
    case .video:
      self.asset = AVURLAsset(url: Bundle.main.url(forResource: "Shortened-vader", withExtension: "mp4")!)
    case .crackling:
      self.asset = AVURLAsset(url: Bundle.main.url(forResource: "crackling", withExtension: "mp3")!)
    }
    self.trackID = CMPersistentTrackID(exactly: type.rawValue)!
  }
}
