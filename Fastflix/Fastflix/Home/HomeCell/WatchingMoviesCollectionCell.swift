//
//  WatchingMoviesCollectionCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 01/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class WatchingMoviesCollectionCell: UICollectionViewCell {
  
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
    
  }
  
  @objc func playBtnDidTap(_ sender: UIButton) {
    
  }
  
  
}
