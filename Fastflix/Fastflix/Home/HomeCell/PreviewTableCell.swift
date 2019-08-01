//
//  PreviewCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 12/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol PreviewTableCellDelegate: class {
  func didSelectItemAt(indexPath: IndexPath)
}

final class PreviewTableCell: UITableViewCell {
  
  static let identifier = "PreviewTableCell"
  
  private var mainURLs: [URL?]?
  private var logoURLs: [URL?]?
  
  private let layout = UICollectionViewFlowLayout()
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  private let sectionHeaderlabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.text = "미리보기"
    label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    return label
  }()
  
  weak var delegate: PreviewTableCellDelegate?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.backgroundColor = .clear
 
    //collectionView register
    collectionView.register(PreviewCollectionCell.self, forCellWithReuseIdentifier: PreviewCollectionCell.identifier)
    addSubViews()
    setupSNP()
    setupCollectionView()
  }
  
  func configure(mainURLs: [String]?, logoURLs: [String]?) {
    let mainArr = mainURLs ?? imageUrls
    let logoArr = logoURLs ?? imageUrls
    
    self.mainURLs = mainArr.map { URL(string: $0) }
    self.logoURLs = logoArr.map { URL(string: $0) }
  }
  
  // MARK: - addSubViews
  private func addSubViews() {
    [collectionView, sectionHeaderlabel].forEach { self.addSubview($0)}
  }
  // MARK: - collectionViewSetUp
  private func setupCollectionView() {
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
    collectionView.showsHorizontalScrollIndicator = false
  }
  // MARK: - snpkitLayout
  private func setupSNP() {
    collectionView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(180)
      $0.top.equalToSuperview()
    }
    sectionHeaderlabel.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().offset(10)
      $0.leading.equalTo(10)
      $0.height.equalTo(5)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension PreviewTableCell: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return mainURLs?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCollectionCell.identifier, for: indexPath) as! PreviewCollectionCell
//    cell.configure(mainURL: mainURLs?[indexPath.row], logoURL: logoURLs?[indexPath.row])
    return cell
  }
  
}

extension PreviewTableCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("indexPath.row: ", indexPath.row)
    delegate?.didSelectItemAt(indexPath: indexPath)
  }
}
