//
//  OriginalTableViewCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 15/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class OriginalTableCell: UITableViewCell {
  
  let sectionHeaderlabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.text = "미리보기"
    label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    return label
  }()
  
  let originalImageView: UIImageView = {
    let imageView = UIImageView()
    
    return imageView
  }()
  
  let layout = UICollectionViewFlowLayout()
  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubViews()
    snpLayout()
    collectionviewSetUp()
  }
  
  // MARK: - addSubViews
  private func addSubViews() {
    [collectionView, sectionHeaderlabel].forEach { self.addSubview($0)}
  }
  
  // MARK: - snapKitLayout
  private func snpLayout() {
    
    sectionHeaderlabel.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().offset(10)
      $0.leading.equalTo(10)
      $0.height.equalTo(5)
    }
    
    collectionView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(180)
      $0.top.equalToSuperview()
    }
    
  }
  
  private func collectionviewSetUp() {
    layout.scrollDirection = .horizontal
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .clear
    self.collectionView.collectionViewLayout = layout
    layout.sectionInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    layout.itemSize = CGSize(width: 110, height: 110)
    
    layout.sectionHeadersPinToVisibleBounds = true
  }
  

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
extension OriginalTableCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: <#T##String#>, for: <#T##IndexPath#>)
    return cell
  }
  
  
}

extension OriginalTableCell: UICollectionViewDelegate {
  
}
