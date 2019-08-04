//
//  ImageCell.swift
//  CollectionViewNetflix
//
//  Created by hyeoktae kwon on 2019/07/09.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Kingfisher

final class ImageCell: UICollectionViewCell {
  static let identifier = "ImageCell"
  
  private let imageView: UIImageView = {
    let img = UIImageView()
    img.contentMode = .scaleAspectFill
    img.backgroundColor = .darkGray
    img.clipsToBounds = true
    return img
  }()
  
  func configure(url: URL) {
    imageView.kf.setImage(with: url, options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 200))), .cacheOriginalImage])
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    [imageView].forEach { addSubview($0) }
    
    imageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalTo(contentView)
    }
  }
  
}
