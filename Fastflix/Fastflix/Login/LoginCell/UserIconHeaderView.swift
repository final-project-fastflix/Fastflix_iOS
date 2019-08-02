//
//  UserIconHeaderView.swift
//  Fastflix
//
//  Created by HongWeonpyo on 02/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class UserIconHeaderView: UITableViewHeaderFooterView {

  let headerLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .clear
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 18)
    return label
  }()

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    
    configure()
    addSubview()
    setupSNP()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure() {
    self.contentView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
  }
  
  func addSubview() {
    contentView.addSubview(headerLabel)
  }
  
  func setupSNP() {
    headerLabel.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(40)
    }
  }
  
}
