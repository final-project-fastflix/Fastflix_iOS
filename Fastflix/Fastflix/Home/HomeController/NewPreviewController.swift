//
//  NewPreviewController.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/08/21.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

final class NewPreviewController: UIViewController {

  let mainView = NewPreView()
  
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
