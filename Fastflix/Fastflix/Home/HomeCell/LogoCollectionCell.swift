//
//  LogoCollectionCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 05/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

protocol LogoCollectionCellDelegate {
  func dismissBtnDidTap()
}

class LogoCollectionCell: UICollectionViewCell {
  
  static let identifier = "LogoCollectionCell"
  
  var delegate: LogoCollectionCellDelegate?
  
  var logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "preViewLogo")
    return imageView
  }()
  
  var progressBar: UISlider = {
    let slider = UISlider()
    slider.tintColor = .white
    slider.thumbTintColor = .clear
    return slider
    
  }()
  
  private let dismissBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.addTarget(self, action: #selector(dismissBtnDidTap(_:)), for: .touchUpInside)
    button.setImage(UIImage(named: "x"), for: .normal)
    return button
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor = .clear
    addSubViews()
    setupSNP()
    
  }
  
  private func addSubViews() {
    [logoImageView, progressBar, dismissBtn].forEach {
      self.addSubview($0)
    }
  }
  
  private func setupSNP() {
    progressBar.snp.makeConstraints {
      $0.top.equalToSuperview()
      
    }
    
    logoImageView.snp.makeConstraints {
      $0.top.equalTo(progressBar.snp.bottom).offset(10)
      $0.width.height.equalTo(200)
    }
    
    dismissBtn.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview().inset(10)
    }
  }
  
  @objc private func dismissBtnDidTap(_ sender: UIButton) {
    print(" 뒤로가여 ")
    delegate?.dismissBtnDidTap()
    
  }
  
  
}
