//
//  PlayCollectionViewCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 06/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import AVKit

class PlayCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "PlayCollectionViewCell"
  
  var playerItem: AVPlayerItem?
  lazy var player = AVPlayer(playerItem: playerItem)
  
  private func setupPlayer() {
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = UIScreen.main.bounds
    self.layer.addSublayer(playerLayer)
    player.play()
    
  }
  
  
}
