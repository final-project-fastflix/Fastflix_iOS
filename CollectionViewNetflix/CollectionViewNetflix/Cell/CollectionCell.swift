//
//  CollectionView.swift
//  CollectionViewNetflix
//
//  Created by hyeoktae kwon on 2019/07/09.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class CollectionCell: UITableViewCell {
  
  static let identifier = "CollectionCell"
  
  // Properties
  private var urls: [URL?]?

  private let layout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
  
  // initialize
  func configure(url: [String]) {
    self.urls = url.map { URL(string: $0) }
  }
  
  // setupAutoLayout
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    [collectionView].forEach { addSubview($0) }
    
    collectionView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    layout.minimumLineSpacing = 15
    layout.minimumInteritemSpacing = 15
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.height / 5)
    layout.scrollDirection = .horizontal
    
    collectionView.register(
      ImageCell.self,
      forCellWithReuseIdentifier: ImageCell.identifier)
    
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = .darkGray
    collectionView.dataSource = self
    
  }
  
}

extension CollectionCell: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return urls?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
    
    cell.configure(url: urls![indexPath.row]!)
    
    return cell
  }
  
}
