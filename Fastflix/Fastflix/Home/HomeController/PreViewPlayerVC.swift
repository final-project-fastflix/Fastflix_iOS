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
  
  weak var delegate: PreViewPlayerVCDelegate?
  
  var mainURLs: [URL?]?
  var logoURLs: [URL?]?
  var idArr: [Int?]?
  var playerItems: [URL?]?
  
//  private let url = URL(string: preViewUrl)!
  
  
//  private let playerViewController: AVPlayerViewController = {
//    let playerVC = AVPlayerViewController()
//
//    return playerVC
//  }()
  
  override func loadView() {
    let preViewPlayerView = PreViewPlayerView()
    preViewPlayerView.delegate = self
    preViewPlayerView.logoURLs = logoURLs
    preViewPlayerView.playerItems = playerItems
    preViewPlayerView.idArr = idArr
    self.view = preViewPlayerView
    view.backgroundColor = .white
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .clear
  }
  
  @objc func dismissBtnDidTap(_ sender: UIButton) {
    delegate?.finishVideo()
    
  }
  
  @objc func didFinishVideo(_ sender: NSNotification) {
    delegate?.finishVideo()
    dismiss(animated: true)
  }
  
  
}


extension PreViewPlayerVC: PreViewPlayerViewDelegate {
  func dismissBtnDidTap() {
    delegate?.finishVideo()
    self.dismiss(animated: true)
  }
  
  
}
