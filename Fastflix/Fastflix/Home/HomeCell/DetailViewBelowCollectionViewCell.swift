//
//  DetailCollectionViewCell.swift
//  Fastflix
//
//  Created by HongWeonpyo on 17/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailViewBelowCollectionViewCell: UICollectionViewCell {
  
  var movieId: Int?
  
  let detailImageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    configure()
    setupSNP()
  }
  
  private func configure() {
    detailImageView.contentMode = .scaleToFill
  }
  
  private func setupSNP() {
    self.addSubview(detailImageView)
    
    detailImageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureImage(imageURLString: String?) {
    let imageURL = URL(string: imageURLString ?? "ImagesData.shared.imagesUrl[5]")
    self.detailImageView.kf.setImage(with: imageURL, options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))), .scaleFactor(UIScreen.main.scale)])
  }
  
  
}
