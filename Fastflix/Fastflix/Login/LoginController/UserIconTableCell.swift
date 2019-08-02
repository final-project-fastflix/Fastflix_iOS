//
//  UserIconTableCell.swift
//  Fastflix
//
//  Created by HongWeonpyo on 02/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

protocol UserIconCollectionCellDelegate:class {
  func collectionView(collectioncell: UserIconCollectionViewCell?, imageURL: String, didTappedInTableview TableCell: UserIconTableCell)
}


class UserIconTableCell: UITableViewCell {
  
  weak var cellDelegate: UserIconCollectionCellDelegate?
  
  lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero)
    collectionView.dataSource = self
    collectionView.delegate = self
    return collectionView
  }()
  
  let flowLayout = UICollectionViewFlowLayout()
  
  var aCategory: String?
  var itemsByCategory: [ProfileImageElement]?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubViews()
    setupSNP()
    setupCollectionViewFlowLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupTableViewCell(category: String, items: [ProfileImageElement]) {
    self.aCategory = category
    self.itemsByCategory = items
    self.collectionView.reloadData()
  }
  
  private func setupCollectionViewFlowLayout() {
    flowLayout.scrollDirection = .horizontal
    flowLayout.itemSize = CGSize(width: 100, height: 100)
    flowLayout.minimumLineSpacing = 10
    flowLayout.minimumInteritemSpacing = 10
    flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    self.collectionView.collectionViewLayout = flowLayout
    self.collectionView.showsHorizontalScrollIndicator = false
    
    collectionView.register(UserIconCollectionViewCell.self, forCellWithReuseIdentifier: "UserIconCollectionViewCell")
    collectionView.register(UserIconHeaderView.self, forSupplementaryViewOfKind: "UserIconHeaderView", withReuseIdentifier: "UserIconHeaderView")
  }

  private func addSubViews() {
    contentView.addSubview(collectionView)
  }
  
  private func setupSNP() {
    collectionView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
}

// MARK: - 컬렉션뷰의 데이터 소스
extension UserIconTableCell: UICollectionViewDataSource {

  // 각 테이블뷰안의 컬렉션뷰는 섹션이 1개로 고정
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  // 각 테이블셀의 컬렉션뷰의 아이템 갯수
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let iconImagesByCategory = itemsByCategory {
      return iconImagesByCategory.count
    } else {
      return 0
    }
  }
  
  // MARK: - 컬렉션뷰 셀의 설정
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserIconCollectionViewCell", for: indexPath) as? UserIconCollectionViewCell
    
    if let item = self.itemsByCategory?[indexPath.item] {
      let name = item.name ?? "일단"
      cell?.configureImage(name: name, imageURLString: item.imagePath)
    }
    return cell!
  }
  
//  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UserIconHeaderView", for: indexPath) as? UserIconHeaderView
//
//      headerView?.headerLabel.text = aCategory
//      return headerView!
//
//  }
}


// MARK: - 델리게이트 구현(테이블뷰안의 컬렉션뷰 셀을 한개 선택했을때의 동작)
extension UserIconTableCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let cell = collectionView.cellForItem(at: indexPath) as? UserIconCollectionViewCell
    guard let url = cell?.imageURL else { return }
    self.cellDelegate?.collectionView(collectioncell: cell, imageURL: url, didTappedInTableview: self)
  }
  
}

