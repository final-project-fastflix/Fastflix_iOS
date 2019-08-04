//
//  OriginalCollectionCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 15/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

final class OriginalCollectionCell: UICollectionViewCell {
  
  static let identifier = "OriginalCollectionCell"
  
  private let originalImageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.addSubview(originalImageView)
    setupSNP()
    
  }
  
  func configure(imageUrlString: String) {
    originalImageView.kf.setImage(with: URL(string: imageUrlString), options: [.processor(CroppingImageProcessor(size: CGSize(width: 170, height: 300))), .scaleFactor(UIScreen.main.scale)])
  }
  
  private func setupSNP() {
    originalImageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()

    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
