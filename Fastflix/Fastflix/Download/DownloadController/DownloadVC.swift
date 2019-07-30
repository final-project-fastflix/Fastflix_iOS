//
//  DownloadVC.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/07/22.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//


import UIKit

class DownloadVC: UIViewController {
  
  let downloadView = DownloadView()
  let emptyDownloadView = EmptyDownloadView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func loadView() {
    //    self.view = downloadView
    self.view = emptyDownloadView
    setupNavi()
    view.backgroundColor = .clear
    navigationController?.navigationBar.isHidden = true
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  
  private func setupNavi() {
    navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "wifiSave"), landscapeImagePhone: nil, style: .done, target: nil, action: nil)
  }
  
  
}

