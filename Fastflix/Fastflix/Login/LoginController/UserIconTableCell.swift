//
//  UserIconTableCell.swift
//  Fastflix
//
//  Created by HongWeonpyo on 02/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

protocol UserIconCollectionCellDelegate: class {
  func collectionViewCellDidTap(collectioncell: UserIconCollectionViewCell?, imageURL: String, didTappedInTableview TableCell: UserIconTableCell)
}


class UserIconTableCell: UITableViewCell {
  
  let headerLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    label.font = UIFont.systemFont(ofSize: 18)
    return label
  }()
  
  weak var cellDelegate: UserIconCollectionCellDelegate?
  
  lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.itemSize = CGSize(width: 100, height: 100)
    flowLayout.minimumLineSpacing = 10
    flowLayout.minimumInteritemSpacing = 0
    flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 5, right: 0)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    return collectionView
  }()
  
  var aCategory: String?
  
  var itemsByCategory: [ProfileImageElement]?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubViews()
    setupSNP()
    setupCollectionView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupTableViewCell(category: String, items: [ProfileImageElement]) {
    self.aCategory = category
    self.itemsByCategory = items
    self.collectionView.reloadData()
  }
  
  private func setupCollectionView() {
  
    collectionView.register(UserIconCollectionViewCell.self, forCellWithReuseIdentifier: "UserIconCollectionViewCell")
  }

  private func addSubViews() {
    contentView.addSubview(headerLabel)
    contentView.addSubview(collectionView)
  }
  
  private func setupSNP() {
    headerLabel.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(40)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(120)
    }
  }
}

// MARK: - 컬렉션뷰의 데이터 소스
extension UserIconTableCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserIconCollectionViewCell", for: indexPath) as? UserIconCollectionViewCell
    
    // 컬렉션뷰의 각 셀에는 이미지 경로만 전달
    if let imagePath = itemsByCategory?[indexPath.item].imagePath {
      cell?.configureImage(imageURLString: imagePath)
    }
    return cell!
  }
  
  
  // 각 테이블뷰안의 컬렉션뷰는 섹션이 1개로 고정
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  // 각 테이블셀의 컬렉션뷰의 아이템 갯수
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let items = itemsByCategory {
      return items.count
    } else {
      return 0
    }
  }
}


// MARK: - 델리게이트 구현(테이블뷰안의 컬렉션뷰 셀을 한개 선택했을때의 동작)
extension UserIconTableCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("클릭됨??????")
    let cell = collectionView.cellForItem(at: indexPath) as? UserIconCollectionViewCell
    guard let url = cell?.imageURL else { return }
    self.cellDelegate?.collectionViewCellDidTap(collectioncell: cell, imageURL: url, didTappedInTableview: self)
  }
  
}

