//
//  MyContentCollectionCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 25/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit


class MyContentCollectionCell: UICollectionViewCell {
  
  let pokeImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  static let identifier = "MyContentCollectionCell"
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubViews()
    setupSNP()
  }
  
  private func addSubViews() {
    [pokeImageView]
      .forEach { self.addSubview($0) }
  }
  
  private func setupSNP() {
    pokeImageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
//       $0.top.leading.trailing.bottom.equalTo(contentView)
      
    }
  }
  
  func configure(imageUrlString: String) {
      pokeImageView.kf.setImage(with: URL(string: imageUrlString), options: [.processor(CroppingImageProcessor(size: CGSize(width: 150, height: 200))), .scaleFactor(UIScreen.main.scale)])
  }
  
  
  
  
  
}
