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
    let imageView = UIImageView()
    return imageView
  }()
  
  
  private let playBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "watchingPlay"), for: .normal)
    button.addTarget(self, action: #selector(playBtnDidTap(_:)), for: .touchUpInside)
    return button
  }()
  
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubViews()
    setupSNP()
  }
  
  private func addSubViews() {
    [imageView, playBtn].forEach { self.addSubview($0) }
  }
  
  private func setupSNP() {
    imageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    playBtn.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
  
  @objc func playBtnDidTap(_ sender: UIButton) {
    print("playBtnDidTap Tap")
  }
  
  func configure(imageUrlString: String) {
    imageView.kf.setImage(with: URL(string: imageUrlString), options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 400, height: 200))), .cacheOriginalImage])
  }
  
  
}
