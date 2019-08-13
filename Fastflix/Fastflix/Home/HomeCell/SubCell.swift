//
//  MainCell.swift
//  TestCollectionViewFastflix
//
//  Created by hyeoktae kwon on 2019/07/13.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

protocol SubTableCellDelegate: class {
  func didSelectItemAt(movieId: Int, movieInfo: MovieDetail)
  func errOccurSendingAlert(message: String, okMessage: String)
}


class SubCell: UITableViewCell {
  
  static let identifier = "SubCell"
  
  private var urls: [URL?] = []
  private var movieIDs: [Int] = []
  
  private let layout = UICollectionViewFlowLayout()
  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    label.font = UIFont.boldSystemFont(ofSize: 18)
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
  
  weak var delegate: SubTableCellDelegate?
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    [collectionView, titleLabel].forEach { addSubview($0) }
    
    let width = UIScreen.main.bounds.width / 3.45
    let height = width * 1.4380
    
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
    layout.minimumLineSpacing = 8
    layout.minimumInteritemSpacing = 15
    layout.itemSize = CGSize(width: width, height: height)
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
      $0.height.equalTo(210)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.top.equalToSuperview().offset(10)
    }
    
    collectionView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
      $0.bottom.equalToSuperview()
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
    print("아이디 출력해보기", id)
    APICenter.shared.getDetailData(id: id) { (result) in
      switch result {
      case .success(let movie):
        print("!!!need to bind Data!!!", movie)
        print("value: ", movie)
        self.delegate?.didSelectItemAt(movieId: movie.id, movieInfo: movie)
        
      case .failure(let err):
        dump(err)
        print("fail to login, reason: ", err)
        
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
