//
//  WatchingMoviesCollectionCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 01/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher


class WatchingMoviesCollectionCell: UICollectionViewCell {
 
  static let identifier = "WatchingMoviesCollectionCell"
  
  private let imageView: UIImageView = {
    let img = UIImageView()
    img.contentMode = .scaleAspectFill
    img.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    img.clipsToBounds = true
    return img
  }()
  
  
  private let playBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "blurplayBtn"), for: .normal)
    button.addTarget(self, action: #selector(playBtnDidTap(_:)), for: .touchUpInside)
//    button.alpha = 0.7
    return button
  }()
  
  
  private let bottomView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()
  
  private let infoBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "info"), for: .normal)
    button.addTarget(self, action: #selector(infoBtnDidTap(_:)), for: .touchUpInside)
    button.tintColor = .gray
    return button
  }()
  
  
  private let playTimeLabel: UILabel = {
    let label = UILabel()
    label.text = "2시간 5분"
    label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    label.textColor = .gray
    return label
  }()
  
  lazy var progressBar: UISlider = {
    
    let slider = UISlider()
    slider.tintColor = .red
    slider.thumbTintColor = .clear
//    slider.thumbRect(forBounds: CGRect, trackRect: <#T##CGRect#>, value: <#T##Float#>)
    return slider
  }()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    addSubViews()
    setupSNP() 
    
  }
  
  func configure(imageUrlString: String) {
    
    imageView.kf.setImage(with: URL(string: imageUrlString), options: [.processor(CroppingImageProcessor(size: CGSize(width: 170, height: 300))), .scaleFactor(UIScreen.main.scale)])
  }
  
  private func addSubViews() {
    [imageView, playBtn, progressBar, bottomView].forEach { addSubview($0) }
    [playTimeLabel, infoBtn, ].forEach {
      bottomView.addSubview($0)
    }
  }
  
  private func setupSNP() {
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(-30)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo((UIScreen.main.bounds.width - 44)/3 * 1.6)
    }
    playBtn.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-5)
    }

    progressBar.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(-15)
      $0.leading.trailing.equalToSuperview()
    }

    bottomView.snp.makeConstraints {
      $0.top.equalTo(progressBar.snp.bottom).offset(-10)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.height * 0.1)
    }

    playTimeLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(7)
      $0.leading.equalToSuperview().inset(10)
    }

    infoBtn.snp.makeConstraints {
      $0.top.equalToSuperview().offset(5)
      $0.trailing.equalToSuperview().inset(10)
    }
  }
  
  @objc func playBtnDidTap(_ sender: UIButton) {
    print("playBtnDidTap Tap")
  }
  
  
  @objc func infoBtnDidTap(_ sender: UIButton) {
    print("infoButton Did Tap")
  }
  
}
