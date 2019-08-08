//
//  LaunchScreenVC.swift
//  Fastflix
//
//  Created by Jeon-heaji on 16/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
// LaunchScreen - rootViewController

final class LaunchScreenVC: UIViewController {
  lazy var launchView = LaunchView()
  
  override func loadView() {
    DataCenter.shared.downloadDatas()
    self.view = launchView
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
//    UIView.animate(withDuration: 2) { [weak imageView = launchView.imageView] in
//      imageView?.alpha = 1
//    }
    
    // 3초 뒤에 뷰 컨트롤러를 띄우는거
    Timer.scheduledTimer(withTimeInterval: 6.5, repeats: false) { _ in
      let appDelegate =  AppDelegate.instance
      appDelegate.checkLoginState()
    }
  }
  
  
}

