//
//  PlayerVC.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/08/06.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import AVKit

final class PlayerVC: UIViewController {
  
  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  private var player: AVPlayer?
  
  private let playerView = PlayerView()
  
  private var timer: Timer?
  
  private var timeObserver: Any?
  
  var urlString: String?
  
  var movieID: Int?
  
  var movieTitle: String?
  
  var seekTime: Int?
  
  // Propertiese
  private let videoPlayerView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    playerView.delegate = self
    
    setupAutoLayout()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupVideoPlayer()
    resetTimer()
  }
  
  func configure(id: Int?, title: String?, videoPath: String?, seekTime: Int?) {
    self.urlString = videoPath
    self.movieTitle = title
    self.movieID = id
    self.seekTime = seekTime
  }
  
  private func resetTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(hideNavigator), userInfo: nil, repeats: false)
  }
  
  @objc private func hideNavigator() {
    playerView.hideNavigator()
  }
  
  @objc private func tapScreen() {
    print("run")
    playerView.showNavigator()
    resetTimer()
  }
  
  
  
  private func setupVideoPlayer() {
    
    playerView.titleLabel.text = movieTitle ?? "No Title"
    
    guard let url = URL(string: urlString ?? streamingUrl) else { return }
    
    player = AVPlayer(url: url)
    
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = videoPlayerView.bounds
    videoPlayerView.layer.addSublayer(playerLayer)
    player?.play()
    
    let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (elapsedTime) in
      self.updateVideoPlayerSlider()
    })
    
    guard let seek = seekTime else { return }
    let seekPoint = CMTime(seconds: Double(seek), preferredTimescale: 1)
    player?.seek(to: seekPoint)
  }
  
  private func updateVideoPlayerSlider() {
    guard let currentTime = player?.currentTime() else { return }
    let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
    playerView.progressSliderValue = Float(currentTimeInSeconds)
    if let currentItem = player?.currentItem {
      let duration = currentItem.duration
      if CMTIME_IS_INVALID(duration) {
        return
      }
      let currentTime = currentItem.currentTime()
      playerView.progressSliderValue = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
      
      // Update time remaining Label
      let totalTimeInSeconds = CMTimeGetSeconds(duration)
      let remainingTimeInSeconds = totalTimeInSeconds - currentTimeInSeconds
      
      let mins = remainingTimeInSeconds / 60
      let secs = remainingTimeInSeconds.truncatingRemainder(dividingBy: 60)
      let timeFormatter = NumberFormatter()
      
      timeFormatter.minimumIntegerDigits = 2
      timeFormatter.minimumFractionDigits = 0
      timeFormatter.roundingMode = .down
      guard let minsString = timeFormatter.string(from: NSNumber(value: mins)), let secsString = timeFormatter.string(from: NSNumber(value: secs)) else { return }
      playerView.timeLabelText = "\(minsString):\(secsString)"
    }
    
    
    
  }
  
  private func setupAutoLayout() {
    view.addSubview(videoPlayerView)
    view.addSubview(playerView)
    //    view.sendSubviewToBack(videoPlayerView)
    
    videoPlayerView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    playerView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    appDelegate.shouldSupportAllOrientation = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    appDelegate.shouldSupportAllOrientation = true
  }
  
}

extension PlayerVC: PlayerViewDelegate {
  func didTapDismiss() {
    appDelegate.shouldSupportAllOrientation = true
    dismiss(animated: true) {
      self.player?.pause()
      guard let currentTime = self.player?.currentTime() else { return }
      let bySecond = Int(CMTimeGetSeconds(currentTime))
      APICenter.shared.postPauseTime(movieID: self.movieID, time: bySecond) {
        switch $0 {
        case .success(let value):
          print("saved? :", value)
        case .failure(let err):
          dump(err)
          print("saved? :", err)
        }
      }
      self.player = nil
    }
    
  }
  
  func didTapScreen() {
    tapScreen()
  }
  
  func jumpForward() {
    guard let currentTime = player?.currentTime() else { return }
    let currentTimeInSecondsPlus10 = CMTimeGetSeconds(currentTime).advanced(by: 10)
    let seekTime = CMTime(value: CMTimeValue(currentTimeInSecondsPlus10), timescale: 1)
    player?.seek(to: seekTime)
  }
  
  func jumpBackward() {
    guard let currentTime = player?.currentTime() else { return }
    let currentTimeInSecondsMinus10 = CMTimeGetSeconds(currentTime).advanced(by: -10)
    let seekTime = CMTime(value: CMTimeValue(currentTimeInSecondsMinus10), timescale: 1)
    player?.seek(to: seekTime)
  }
  
  func timeSeeking(value: Float64) {
    guard let duration = player?.currentItem?.duration else { return }
    let value = value * CMTimeGetSeconds(duration)
    guard !value.isNaN else { return }
    let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
    player?.seek(to: seekTime)
  }
  
  func didTapPlay() {
    player!.isPlaying ? player?.pause() : player?.play()
  }
}

extension AVPlayer {
  var isPlaying: Bool {
    return rate != 0 && error == nil
  }
}

