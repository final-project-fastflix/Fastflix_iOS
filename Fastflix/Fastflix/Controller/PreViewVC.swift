//
//  PreViewVC.swift
//  Fastflix
//
//  Created by Jeon-heaji on 15/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import AVKit

class PreViewPlayerVC: UIViewController {
  
  let dismissBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "x"), for: .normal)
    button.addTarget(self, action: #selector(dismissBtnDidTap(_:)), for: .touchUpInside)
    
    return button
  }()
  
 
  let playerViewController = AVPlayerViewController()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(dismissBtn)
    view.backgroundColor = .clear
    snpLayout()
  }
  
  @objc func dismissBtnDidTap(_ sender: UIButton) {
    dismiss(animated: true)
    print("taptap")
  }
  
  private func snpLayout() {
    dismissBtn.snp.makeConstraints {
      $0.top.equalTo(50)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(40)
    }
  }
  
}
