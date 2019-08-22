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
import AVKit

protocol PreviewTableCellDelegate: class {
  func didSelectItemAt(indexPath: IndexPath, logoArr: [URL?]?, videoItems: [URL?]?, idArr: [Int]?)
}

final class PreviewTableCell: UITableViewCell {
  
  static let identifier = "PreviewTableCell"
  
  var mainURLs: [URL?]?
  var logoURLs: [URL?]?
  var videoPaths: [URL?]?
  var idArr: [Int]?
  var playerItems: [AVPlayerItem]?
  
  private let layout = UICollectionViewFlowLayout()
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  private let sectionHeaderlabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.text = "미리보기"
    label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
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
  
  func configure(idArr: [Int], mainURLs: [String], logoURLs: [String], videos: [String]) {
    let mainArr = mainURLs
    let logoArr = logoURLs
    let videoArr = videos
    
    self.mainURLs = mainArr.map { URL(string: $0) }
    self.logoURLs = logoArr.map { URL(string: $0) }
    self.videoPaths = videoArr.map { URL(string: $0) }
    self.idArr = idArr
//    guard let path = videoPaths else { return }
//    self.playerItems = path.map { AVPlayerItem(url: $0!) }
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
    contentView.snp.makeConstraints {
      $0.height.equalTo(180)
    }
    collectionView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
//      $0.height.equalTo(180)
    
    }
    sectionHeaderlabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.top.equalToSuperview().offset(10)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension PreviewTableCell: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return logoURLs?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCollectionCell.identifier, for: indexPath) as! PreviewCollectionCell
    cell.configure(mainURL: mainURLs?[indexPath.row], logoURL: logoURLs?[indexPath.row])
    return cell
  }
  
}

extension PreviewTableCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    print("indexPath.row: ", indexPath.row)
    delegate?.didSelectItemAt(indexPath: indexPath, logoArr: logoURLs!, videoItems: videoPaths!, idArr: idArr!)
    
  }
}
