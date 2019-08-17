//
//  BaseVC.swift
//  TestPreview
//
//  Created by hyeoktae kwon on 2019/08/18.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class BaseVC: UIViewController {
  
  let btn: UIButton = {
    let btn = UIButton()
    btn.setTitle("present", for: .normal)
    btn.setTitleColor(.black, for: .normal)
    btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
    btn.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
    return btn
  }()

    override func viewDidLoad() {
        super.viewDidLoad()
      view.addSubview(btn)
      btn.snp.makeConstraints {
        $0.centerX.centerY.equalToSuperview()
      }
        // Do any additional setup after loading the view.
    }
  
  @objc func next(_ sender: UIButton) {
    present(MainController(), animated: true)
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
