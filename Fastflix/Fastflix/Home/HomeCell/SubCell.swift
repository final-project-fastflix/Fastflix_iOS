//
//  MainCell.swift
//  TestCollectionViewFastflix
//
//  Created by hyeoktae kwon on 2019/07/13.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class SubCell: UITableViewCell {
  
  static let identifier = "SubCell"
  
  private var urls: [URL?] = []
  private var movieIDs: [Int] = []
  
  private let layout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    label.font = UIFont.boldSystemFont(ofSize: 20)
    return label
  }()
  
  func configure(url: [String]?, title: String?, movieIDs: [Int]?) {
    let urlArr = url ?? imageUrls
    let idArr = movieIDs ?? []
    let title = title ?? "title"
    
    self.urls = urlArr.map { URL(string: $0) }
    self.titleLabel.text = title
    self.movieIDs = idArr
    self.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    [collectionView, titleLabel].forEach { addSubview($0) }
    
    layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    layout.minimumLineSpacing = 15
    layout.minimumInteritemSpacing = 15
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.height / 4.8)
    layout.scrollDirection = .horizontal
    
    collectionView.register(
      ImageCell.self,
      forCellWithReuseIdentifier: ImageCell.identifier)
    
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    collectionView.dataSource = self
    collectionView.delegate = self
    setupSNP()
  }
  
  private func setupSNP() {
    
    contentView.snp.makeConstraints {
      $0.height.equalTo(220)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.top.equalToSuperview().offset(10)
    }
    
    collectionView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
      $0.bottom.equalToSuperview().offset(-10)
    }
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

extension SubCell: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return movieIDs.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell

    cell.configure(url: urls[indexPath.row], movieID: movieIDs[indexPath.row])
    
    return cell
  }
  
}

extension SubCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let id = movieIDs[indexPath.row]
    APICenter.shared.getDetailData(id: id) { (result) in
      switch result {
      case .success(let value):
        print("!!!need to bind Data!!!", value)
      case .failure(let err):
        dump(err)
      }
    }
  }
}
