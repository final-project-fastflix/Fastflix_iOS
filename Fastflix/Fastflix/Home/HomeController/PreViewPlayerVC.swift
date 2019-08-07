//
//  PreViewPlayerVC.swift
//  Fastflix
//
//  Created by Jeon-heaji on 15/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import AVKit

protocol PreViewPlayerVCDelegate: class {
  func finishVideo()
}

final class PreViewPlayerVC: UIViewController {
  
  private weak var delegate: PreViewPlayerVCDelegate?
  
  var mainURLs: [URL?]?
  var logoURLs: [URL?]?
  var idArr: [Int?]?
  var playerItems: [AVPlayerItem]?
  
//  private let url = URL(string: preViewUrl)!
  
  
//  private let playerViewController: AVPlayerViewController = {
//    let playerVC = AVPlayerViewController()
//
//    return playerVC
//  }()
  
  override func loadView() {
    let preViewPlayerView = PreViewPlayerView()
    preViewPlayerView.logoURLs = logoURLs
    preViewPlayerView.playerItems = playerItems
    preViewPlayerView.idArr = idArr
    self.view = preViewPlayerView
    view.backgroundColor = .white
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
//    NotificationCenter.default.addObserver(self, selector: #selector(didFinishVideo(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)
//
//    let player = AVPlayer(url: url)
//    playerViewController.player = player
//    present(playerViewController, animated: true) {
//      player.play()
//    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .clear
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupSNP()
  }
  
  @objc func dismissBtnDidTap(_ sender: UIButton) {
    delegate?.finishVideo()
  }
  
  private func setupSNP() {

  }
  
  @objc func didFinishVideo(_ sender: NSNotification) {
    dismiss(animated: true)
  }
  
  
}
