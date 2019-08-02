//
//  LaunchView.swift
//  Fastflix
//
//  Created by Jeon-heaji on 02/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit


class LaunchView: UIView {
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "launchlogo3")
    imageView.contentMode = .scaleAspectFill
    imageView.alpha = 0
    return imageView
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubViews()
    setupSNP()
  }
  
  private func addSubViews() {
    [imageView].forEach { addSubview($0) }
  }
  
  private func setupSNP() {
    imageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  

  

}
