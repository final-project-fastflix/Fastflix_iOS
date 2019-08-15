//
//  CollectionViewCell.swift
//  TestPreview
//
//  Created by hyeoktae kwon on 2019/08/15.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
  static let identifier = "CollectionViewCell"
  
  let imgView = UIImageView(image: UIImage(named: "launchlogo3"))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
//    imgView.snp.makeConstraints {
//      $0.top.leading.trailing.bottom.equalToSuperview()
//    }
    self.backgroundColor = .white
    imgView.frame = UIScreen.main.bounds
    self.addSubview(imgView)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
