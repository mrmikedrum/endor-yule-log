//
//  PlayerView.swift
//  Endor Yule Log
//
//  Created by Mike Drum on 12/24/16.
//
//

import UIKit
import AVFoundation

class PlayerView: UIView {

  var player: AVPlayer? {
    get {
      return playerLayer.player
    }
    set {
      playerLayer.player = newValue
    }
  }
  
  var playerLayer: AVPlayerLayer {
    return layer as! AVPlayerLayer
  }
  
  // Override UIView property
  override static var layerClass: AnyClass {
    return AVPlayerLayer.self
  }
}
