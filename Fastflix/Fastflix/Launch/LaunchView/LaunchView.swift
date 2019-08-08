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
    imageView.contentMode = .scaleAspectFit
    imageView.alpha = 1
    return imageView
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor = .black
    addSubViews()
    setupSNP()
    
    imageView.image = UIImage.gifImageWithURL(gifUrl: "https://firebasestorage.googleapis.com/v0/b/test-e3f46.appspot.com/o/fastGIfWhite.gif?alt=media&token=6e9f22a5-93c1-4373-b712-b3ce8f15e9dc")
  }
  
  private func addSubViews() {
    [imageView].forEach { addSubview($0) }
  }
  
  private func setupSNP() {
    imageView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(50)
      $0.trailing.equalToSuperview().offset(-50)
    }
  }
  

  

}
