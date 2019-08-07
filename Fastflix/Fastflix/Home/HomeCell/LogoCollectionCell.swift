//
//  LogoCollectionCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 05/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit



class LogoCollectionCell: UICollectionViewCell {
  
  static let identifier = "LogoCollectionCell"
  
  
  
  var logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "preViewLogo")
    imageView.backgroundColor = .clear
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  var progressBar: UISlider = {
    let slider = UISlider()
    slider.tintColor = .white
    slider.thumbTintColor = .clear
    return slider
  }()
  

  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor = .clear
    addSubViews()
    setupSNP()
  }
  
  private func addSubViews() {
    [logoImageView, progressBar].forEach {
      self.addSubview($0)
    }
  }
  
  private func setupSNP() {
    progressBar.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.width.equalTo((UIScreen.main.bounds.width / 3) - 40)
      $0.leading.equalToSuperview().offset(20)
//      $0.trailing.equalToSuperview().offset(-15)
      $0.trailing.equalToSuperview().offset(-20)
      
    }
    
    logoImageView.snp.makeConstraints {
      $0.top.equalTo(progressBar.snp.bottom)
//      $0.width.height.equalTo(100)
      $0.width.equalTo(progressBar)
      $0.leading.trailing.equalTo(progressBar)

    }
    
  }
  
}
