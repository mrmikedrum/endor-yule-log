//
//  ViewController.swift
//  Endor Yule Log
//
//  Created by Mike Drum on 12/23/16.
//
//

import UIKit
import AVKit

class ViewController: UIViewController {
  
  private weak var player: AVPlayer!
  @IBOutlet var playerView: PlayerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // create player
    let playerItem = AVPlayerItem(asset: self.createComposition())
    let player = AVPlayer(playerItem: playerItem)
    
    // make player loop the last minute
    let time = NSValue(time: CMTime(seconds: 120, preferredTimescale: 1))
    player.addBoundaryTimeObserver(forTimes: [time], queue: nil) {
      player.seek(to: CMTime(seconds: 60, preferredTimescale: 1))
    }
    
    self.player = player
    playerView.player = player
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // present the controller
    self.player.play()
  }

  private func createComposition() -> AVComposition {
    let composition = AVMutableComposition()
    
    var url = Bundle.main.url(forResource: "crackling", withExtension: "mp3")!
    var asset = AVURLAsset(url: url)
    var track = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID(exactly: 0)!)
    do {
      try track.insertTimeRange(CMTimeRange(start: kCMTimeZero, duration: asset.duration), of: asset.tracks(withMediaType: AVMediaTypeAudio).first!, at: kCMTimeZero)
    } catch {
      print("damn")
    }
    
    url = Bundle.main.url(forResource: "Shortened-vader", withExtension: "mp4")!
    asset = AVURLAsset(url: url)
    track = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID(exactly: 1)!)

    do {
      try track.insertTimeRange(CMTimeRange(start: kCMTimeZero, duration: asset.duration), of: asset.tracks(withMediaType: AVMediaTypeVideo).first!, at: kCMTimeZero)
    } catch {
      print("damn")
    }
    
    return composition
  }

}

