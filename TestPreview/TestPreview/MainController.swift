//
//  MainController.swift
//  TestPreview
//
//  Created by hyeoktae kwon on 2019/08/15.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class MainController: UIViewController {
  
  let mainView = MainView()
  
  override func loadView() {
    self.view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.disMissBtn.addTarget(self, action: #selector(didTapDisMissBtn(_:)), for: .touchUpInside)
  }
  
  @objc func didTapDisMissBtn(_ sender: UIButton) {
    dismiss(animated: true)
  }
}
