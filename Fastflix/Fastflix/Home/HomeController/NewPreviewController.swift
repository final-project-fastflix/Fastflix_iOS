//
//  NewPreviewController.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/08/21.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

final class NewPreviewController: UIViewController {
  
  var mainURLs: [URL?]?
  var logoURLs: [URL?]?
  var idArr: [Int?]?
  var playerItems: [URL?]?

  var mainView: NewPreView? = nil
  
  override func loadView() {
    mainView = NewPreView()
    mainView?.logoURLs = logoURLs
    mainView?.playerItems = playerItems
    mainView?.idArr = idArr
    mainView?.configure()
    self.view = mainView
    
    view.backgroundColor = .clear
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView?.disMissBtn.addTarget(self, action: #selector(didTapDisMissBtn(_:)), for: .touchUpInside)
  }
  
  @objc func didTapDisMissBtn(_ sender: UIButton) {
    guard let count = playerItems?.count else { return }
    
    for idx in 0..<count {
      let index = IndexPath(row: idx, section: 0)
      let cell = mainView?.playerCollectionView.cellForItem(at: index) as? PlayCollectionViewCell
      cell?.player.pause()
      cell?.player.replaceCurrentItem(with: nil)
      //      cell?.player = AVPlayer()
      
      cell?.playerLayer?.removeAllAnimations()
      cell?.playerLayer?.removeFromSuperlayer()
    }
    mainView = nil
    dismiss(animated: true)
  }
  
  deinit {
    mainView = nil
    print("NewPreviewController Deinit")
  }
}
