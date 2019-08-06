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
    static let identifier = "WatchingMoviesCollectionCell"
  
  let logoLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let progressBar: UISlider = {
    let slider = UISlider()
    slider.tintColor = .white
    slider.thumbTintColor = .clear
    return slider
    
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubViews()
    setupSNP()
    
  }
  
  private func addSubViews() {
    [logoLabel, progressBar].forEach {
      self.addSubview($0)
    }
  }
  
  private func setupSNP() {
    
  }
  

}
