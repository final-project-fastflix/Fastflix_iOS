//
//  WatchingMoviesTableCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 01/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

protocol WatchingMoviesTableCellDelegate: class {
  func WatchingMovielDidSelectItemAt(movieId: Int, url: String, movieTitle: String)
}

class WatchingMoviesTableCell: UITableViewCell {
  
  let subUserSingle = SubUserSingleton.shared
  
  static let identifier = "WatchingMoviesTableCell"
  
  var delegate: WatchingMoviesTableCellDelegate?
  
  var baseData: FollowUp?
  
  private let titleLabel: UILabel = {
    let label = UILabel()
//    label.text = "hea 님이 시청중인 콘텐츠"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    return label
  }()
  
  private let layout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    addSubViews()
    setupSNP()
    registerCollectionViewCell()
    setupCollectionView()

  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  func configure(data: FollowUp, subUserName: String?) {
    self.baseData = data
    
    let name = subUserName ?? ""
    
    let title = "\(name) 님이 시청중인 콘텐츠"
    
//    self.urls = urlArr.map { URL(string: $0) }
    self.titleLabel.text = title
    self.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
  }
  

  private func addSubViews() {
    [titleLabel, collectionView]
      .forEach { self.addSubview($0) }

  }
  
  private func setupSNP() {
    
    contentView.snp.makeConstraints {
      $0.height.equalTo(270)
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
  
  // registerCollectionView
  private func registerCollectionViewCell() {
    collectionView.register(WatchingMoviesCollectionCell.self, forCellWithReuseIdentifier: WatchingMoviesCollectionCell.identifier)
  }
 
  
  // MARK: - setupCollectionView
  private func setupCollectionView() {
    
//    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
//    layout.minimumLineSpacing = 15
//    layout.minimumInteritemSpacing = 15
//    layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 4)
//    layout.scrollDirection = .horizontal
//
//    collectionView.showsHorizontalScrollIndicator = false
//    collectionView.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
//    collectionView.dataSource = self
    
    collectionView.dataSource = self
    collectionView.delegate = self
    layout.scrollDirection = .horizontal
    collectionView.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    self.collectionView.collectionViewLayout = layout
    
    // MARK: - 컬렉션뷰 레이아웃 설정
    // 컬렉션뷰의 전체적으로 떨어진 간격 설정(inset)
    layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    // 다음줄(아랫줄)과의 간격설정 - 12
    layout.minimumLineSpacing = 8
    // 옆줄과의 간격설정 - 14
    layout.minimumInteritemSpacing = 14
    // 전체 뷰에서 왼쪽 8, 오른쪽 8, 사이 14 * 2 (전체 44)를 빼고난 나머지 공간을 3줄로 나누기
    let width = UIScreen.main.bounds.width / 3.5
    let height = width * 1.35
    // 컬렉션뷰의 각 한개의 아이템 사이즈 설정
    layout.itemSize = CGSize(width: width, height: height)
    
    layout.sectionHeadersPinToVisibleBounds = true
    collectionView.showsHorizontalScrollIndicator = false
    
  }
  

  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

extension WatchingMoviesTableCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return baseData?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatchingMoviesCollectionCell.identifier, for: indexPath) as! WatchingMoviesCollectionCell
    
    if let data = baseData?[indexPath.row] {
      
//      print("시청중인 콘텐츠",data)
      cell.configure(imageUrl: data.movie.verticalImage, id: data.movie.id, video: data.movie.videoFile ?? "", runningTime: data.totalMinute, progress: data.progressBar, toBe: data.toBeContinue)
//      cell.playBtn.addTarget(self, action: #selector(self.collectionView(_:didSelectItemAt:)), for: .touchUpInside)
    }

    return cell
  }
  
  
}

extension WatchingMoviesTableCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //    print("indexPath.row: ", indexPath.row)
    
    let data = baseData?[indexPath.item]
    let movieId = data?.movie.id ?? 253
    
    APICenter.shared.getDetailData(id: movieId) {
      switch $0 {
      case .success(let movie):
//        print("영화 플레이화면으로 전달: ", movie.id, movie.name)
        
        DispatchQueue.main.async {
          self.delegate?.WatchingMovielDidSelectItemAt(movieId: movieId, url: movie.videoFile, movieTitle: movie.name)
        }
        
      case .failure(let err):
//        print("fail to login, reason: ", err)
        dump(err)
        let message = """
        죄송합니다. 해당 영화에 대한 정보를 가져오지
        못했습니다. 다시 시도해 주세요.
        """
        
      }
    }
  }
}

//extension WatchingMoviesTableCell: CellForBetterTouchButtonCellDelegate {
//  func buttonDidTap(indexPath: IndexPath) {
//    self.collectionView(collectionView, didSelectItemAt: indexPath)
//  }
//}
