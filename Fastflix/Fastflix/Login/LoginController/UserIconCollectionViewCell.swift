//
//  UserIconCollectionViewCell.swift
//  Fastflix
//
//  Created by HongWeonpyo on 02/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Kingfisher


class UserIconCollectionViewCell: UICollectionViewCell {
  
  let mainImageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  var cellImageName:String?
  var imageURL: String?
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
    addSubViews()
    setupSNP()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    self.backgroundColor = UIColor.red
  }
  
  private func addSubViews() {
    contentView.addSubview(mainImageView)
  }
  
  private func setupSNP(){
    mainImageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  func configureImage(name:String?, imageURLString: String?) {
    self.cellImageName = name ?? "일단"
    self.imageURL = imageURLString
    let imageURL = URL(string: imageURLString ?? "ImagesData.shared.imagesUrl[5]")
    self.mainImageView.kf.setImage(with: imageURL, options: [.processor(CroppingImageProcessor(size: CGSize(width: 100, height: 100))), .scaleFactor(UIScreen.main.scale)])
  }
  
}
