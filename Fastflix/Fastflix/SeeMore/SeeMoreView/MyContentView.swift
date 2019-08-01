//
//  MyContentView.swift
//  Fastflix
//
//  Created by Jeon-heaji on 25/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

// 내가 찜한 콘텐츠 뷰 - data 추가
protocol MyContentViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView)
}

class MyContentView: UIView {
  
  var delegate: MyContentViewDelegate?
  
  private let layout = UICollectionViewFlowLayout()
  
  let collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    return collectionView
  }()

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor = .clear
    addSubViews()
    setupSNP()
    setupCollectionView()
    registerCollectionViewCell()
    
  }
  
  private func addSubViews() {
    [collectionView]
      .forEach { self.addSubview($0) }

  }
  
  private func setupSNP() {
    collectionView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }

  }
      // MARK: - setupCollectionView
  private func setupCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    layout.scrollDirection = .vertical
    collectionView.backgroundColor = .black
    self.collectionView.collectionViewLayout = layout
    
    
    layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    layout.minimumLineSpacing = 12
    layout.minimumInteritemSpacing = 14
    let width = (UIScreen.main.bounds.width - 44)/3
    layout.itemSize = CGSize(width: width, height: width * 1.3818)
    
    
    layout.sectionHeadersPinToVisibleBounds = true
    collectionView.showsHorizontalScrollIndicator = false
    
  }
  // registerCollectionView
  private func registerCollectionViewCell() {
    collectionView.register(MyContentCollectionCell.self, forCellWithReuseIdentifier: MyContentCollectionCell.identifier)
  }

}

extension MyContentView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ImagesData.shared.myContentImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyContentCollectionCell.identifier, for: indexPath) as! MyContentCollectionCell
    cell.configure(imageUrlString: ImagesData.shared.myContentImages[indexPath.row])
    return cell
  }
  
}
extension MyContentView: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    delegate?.scrollViewDidScroll(scrollView: scrollView)
    
  }
}
