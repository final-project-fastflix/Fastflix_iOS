//
//  CategorySelectCell.swift
//  Fastflix
//
//  Created by HongWeonpyo on 06/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class CategorySelectCell: UITableViewCell {

  let genreLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18, weight: .light)
    label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    label.textAlignment = .center
    label.backgroundColor = .clear
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configure()
    addSubviews()
    setupSNP()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if isSelected {
      genreLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
      genreLabel.textColor = .white
      selectionStyle = .none
      selectedBackgroundView?.backgroundColor = .clear
    }else {
      genreLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
      genreLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
      selectionStyle = .none
      selectedBackgroundView?.backgroundColor = .clear
    }
  }
  
  private func addSubviews() {
    contentView.addSubview(genreLabel)
  }
  
  private func configure() {
    contentView.backgroundColor = .clear
    self.backgroundColor = .clear
  }
  
  private func setupSNP() {
    genreLabel.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview().inset(10)
      $0.height.equalTo(40)
    }
  }
  
}
