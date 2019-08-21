//
//  OriginalTableCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 15/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//


import UIKit
import SnapKit
import Kingfisher

protocol OriginalTableCellDelegate: class {
  func originalDidSelectItemAt(movieId: Int, movieInfo: MovieDetail)
  func errOccurSendingAlert(message: String, okMessage: String)
}

final class OriginalTableCell: UITableViewCell {
  
  private var urls: [URL?] = []
  private var movieIDs: [Int] = []
  
  static let identifier = "OriginalTableCell"
  
  private let sectionHeaderlabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.text = "Netflix 오리지널 >"
    label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    return label
  }()
  
  private let layout = UICollectionViewFlowLayout()
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  weak var delegate: OriginalTableCellDelegate?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = .clear
    addSubViews()
    setupSNP()
    collectionviewSetUp()
    collectionView.register(OriginalCollectionCell.self, forCellWithReuseIdentifier: OriginalCollectionCell.identifier)
  }
  
  // MARK: - addSubViews
  private func addSubViews() {
    [collectionView, sectionHeaderlabel].forEach { self.addSubview($0)}
  }
  
  // MARK: - snapKitLayout
  private func setupSNP() {
    
    contentView.snp.makeConstraints {
      $0.height.equalTo(290)
    }
    
    sectionHeaderlabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalTo(10)
    }
    
    collectionView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(sectionHeaderlabel.snp.bottom).offset(10)
    }
    
  }
  
  private func collectionviewSetUp() {
    layout.scrollDirection = .horizontal
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .clear
    self.collectionView.collectionViewLayout = layout
    layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    layout.minimumLineSpacing = 7
    layout.minimumInteritemSpacing = 7
    layout.itemSize = CGSize(width: 170, height: 250)
    
    layout.sectionHeadersPinToVisibleBounds = true
    collectionView.showsHorizontalScrollIndicator = false
  }
  
  func configure(url: [String]?, movieIDs: [Int]?) {
    let urlArr = url ?? imageUrls
    let idArr = movieIDs ?? []
    
    self.urls = urlArr.map { URL(string: $0) }
    self.movieIDs = idArr
    self.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
extension OriginalTableCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movieIDs.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OriginalCollectionCell.identifier, for: indexPath) as! OriginalCollectionCell
    
    cell.configure(url: urls[indexPath.row], movieID: movieIDs[indexPath.row])
    
    return cell
  }
  
  
}

extension OriginalTableCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
//    print("오리지널 영화들 아이디 필요")
    
    // 영화 아이디값 있어야 함
    let id = movieIDs[indexPath.row]
    
    APICenter.shared.getDetailData(id: id) { (result) in
      switch result {
      case .success(let movie):
//        print("!!!need to bind Data!!!", movie)
//        print("value: ", movie)
        self.delegate?.originalDidSelectItemAt(movieId: movie.id, movieInfo: movie)

      case .failure(let err):
        dump(err)
//        print("fail to login, reason: ", err)

        let message = """
        죄송합니다. 해당 영화에 대한 정보를 가져오지
        못했습니다. 다시 시도해 주세요.
        """
        let okMessage = "재시도"

        self.delegate?.errOccurSendingAlert(message: message, okMessage: okMessage)
      }
    }
    
  }
}

