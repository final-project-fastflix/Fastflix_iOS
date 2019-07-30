//
//  SearchCollectionCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 28/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class SearchCollectionCell: UICollectionViewCell {
  
  static let identifier = "SearchCollectionCell"
  
  let searchImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addSubViews()
    setupSNP()
  }
  
  private func addSubViews() {
    [searchImageView]
      .forEach { self.addSubview($0) }
  }
  
  private func setupSNP() {
    searchImageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
      //       $0.top.leading.trailing.bottom.equalTo(contentView)
      
    }
  }
  
  func configure(imageUrlString: String) {
    searchImageView.kf.setImage(with: URL(string: imageUrlString), options: [.processor(CroppingImageProcessor(size: CGSize(width: 150, height: 200))), .scaleFactor(UIScreen.main.scale)])
  }
  
  
}
