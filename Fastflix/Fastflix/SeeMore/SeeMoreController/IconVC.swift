//
//  IconVC.swift
//  Fastflix
//
//  Created by Jeon-heaji on 22/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class IconVC: UIViewController {
  
  let label: UILabel = {
    let label = UILabel()
    label.text = "계정관리는 Fastflix 웹사이트로 이동해 진행하세요."
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    return label
  }()

    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
      addSubViews()
      setupSNP()
      title = "Fastflix"
      
    }
  private func addSubViews() {
    [label]
      .forEach { view.addSubview($0) }
  }
  
  private func setupSNP() {
    label.snp.makeConstraints {
      $0.top.equalToSuperview().offset(130)
      $0.leading.trailing.equalToSuperview()
    }
  }
    
}
