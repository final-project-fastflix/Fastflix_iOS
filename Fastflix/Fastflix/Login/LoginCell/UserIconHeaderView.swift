//
//  UserIconHeaderView.swift
//  Fastflix
//
//  Created by HongWeonpyo on 02/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class UserIconHeaderView: UITableViewHeaderFooterView {
  
  class var customView : UserIconHeaderView {
    let cell = UserIconHeaderView()
    return cell 
  }
  
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
    self.backgroundColor = .red
  }
  
  func addSubview() {
    self.addSubview(headerLabel)
  }
  
  func setupSNP() {
    self.snp.makeConstraints {
      $0.height.equalTo(40)
    }
    
    headerLabel.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalTo(contentView)
      $0.height.equalTo(40)
    }
  }
  
}
