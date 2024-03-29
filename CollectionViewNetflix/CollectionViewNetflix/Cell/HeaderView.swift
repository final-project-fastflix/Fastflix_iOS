//
//  HeaderView.swift
//  CollectionViewNetflix
//
//  Created by hyeoktae kwon on 2019/07/09.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class HeaderView: UITableViewCell {
  static let identifier = "HeaderView"
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.backgroundColor = .darkGray
    label.font = UIFont.boldSystemFont(ofSize: 20)
    return label
  }()
  
  func configure(title: String) {
    self.titleLabel.text = title
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    [titleLabel].forEach { addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.centerY.leadingMargin.equalToSuperview()
    }
  }
}
