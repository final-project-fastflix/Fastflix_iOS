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
  
  let mainView = MainView(frame: UIScreen.main.bounds)
  
  override func loadView() {
    self.view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
