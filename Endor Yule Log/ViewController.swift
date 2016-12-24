//
//  ViewController.swift
//  Endor Yule Log
//
//  Created by Mike Drum on 12/23/16.
//
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  @IBOutlet var playerView: PlayerView!
  
  private weak var player: AVPlayer!
  private weak var composition: AVMutableComposition!
  
  private var tracks = [
    TrackType.video: EndorTrack(type: .video, muted: true),
    TrackType.crackling: EndorTrack(type: .crackling, muted: false),
    TrackType.ambient: EndorTrack(type: .ambient, muted: true)
  ]
  
  // MARK: setting up state
  
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
    self.updateAudioMix()
    self.startPlayerFromBeginning()
  }
  
  private func startPlayerFromBeginning() {
    self.player.seek(to: kCMTimeZero)
    self.player.play()
  }

  private func createComposition() -> AVComposition {
    let composition = AVMutableComposition()
    
    // video
    let videoTrack = self.tracks[.video]!
    var track = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: videoTrack.trackID)
    videoTrack.trackID = track.trackID
    
    do {
      try track.insertTimeRange(CMTimeRange(start: kCMTimeZero, duration: videoTrack.asset.duration), of: videoTrack.asset.tracks(withMediaType: AVMediaTypeVideo).first!, at: kCMTimeZero)
    } catch {
    }
    
    // crackling
    var audioTrack = self.tracks[.crackling]!
    track = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: audioTrack.trackID)
    audioTrack.trackID = track.trackID

    do {
      try track.insertTimeRange(CMTimeRange(start: kCMTimeZero, duration: audioTrack.asset.duration), of: audioTrack.asset.tracks(withMediaType: AVMediaTypeAudio).first!, at: kCMTimeZero)
    } catch {
    }
    
    // ambient
    audioTrack = self.tracks[.ambient]!
    track = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: audioTrack.trackID)
    audioTrack.trackID = track.trackID
    
    do {
      try track.insertTimeRange(CMTimeRange(start: kCMTimeZero, duration: audioTrack.asset.duration), of: audioTrack.asset.tracks(withMediaType: AVMediaTypeAudio).first!, at: kCMTimeZero)
    } catch {
    }
    
    return composition
  }
  
  // MARK: updating state
  
  @IBOutlet weak var crackleButton: UIButton!
  @IBAction func crackle(_ sender: UIButton) {
    
    let track = self.tracks[.crackling]!
    
    if track.isMuted {
      self.crackleButton.setTitle("On", for: .normal)
      track.isMuted = false
    } else {
      self.crackleButton.setTitle("Off", for: .normal)
      track.isMuted = true
    }

    self.updateAudioMix()
  }
  
  @IBOutlet weak var ambientButton: UIButton!
  @IBAction func ambient(_ sender: UIButton) {
    let track = self.tracks[.ambient]!
    
    if track.isMuted {
      self.ambientButton.setTitle("On", for: .normal)
      track.isMuted = false
    } else {
      self.ambientButton.setTitle("Off", for: .normal)
      track.isMuted = true
    }
    
    self.updateAudioMix()
  }
  
  private func updateAudioMix() {
    let mix = AVMutableAudioMix()
    
    for track in self.tracks.values {
      let params = AVMutableAudioMixInputParameters()
      params.trackID = track.trackID
      params.setVolume(track.isMuted ? 0 : 1, at: kCMTimeZero)
      mix.inputParameters.append(params)
    }
    
    self.player.currentItem?.audioMix = mix
  }

}

