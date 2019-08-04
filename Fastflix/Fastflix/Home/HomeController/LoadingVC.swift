//
//  LoadingVC.swift
//  Fastflix
//
//  Created by Jeon-heaji on 03/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {
  
  
  
  override func loadView() {
    DataCenter.shared.downloadDatas()
    let loadingView = LoadingView()
    self.view = loadingView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
      let appDelegate =  AppDelegate.instance
      appDelegate.checkLoginState()
    }
    
  }
  
  
}
