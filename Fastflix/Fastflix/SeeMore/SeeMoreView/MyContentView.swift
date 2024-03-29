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
protocol MyContentViewDelegate: class {
  func scrollViewDidScroll(scrollView: UIScrollView)
}

class MyContentView: UIView {
  
  var movieIDArr: [Int] = []
  var imgPaths: [String] = []
  
  weak var delegate: MyContentViewDelegate?
  
  weak var contentDelegate: SubTableCellDelegate?
  
  let path = DataCenter.shared
  
  // 네이게이션뷰
  lazy var navigationView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()

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
    
    
//    if let data = path.forkData {
//      for index in data {
//        imgPaths.append(index.verticalImage)
//        movieIDArr.append(index.id)
//      }
//    }
  }
  
  private func addSubViews() {
    [collectionView, navigationView]
      .forEach { self.addSubview($0) }

  }
  
  private func setupSNP() {
    navigationView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.height * 0.11)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }

  }
  
  func configure(url: [String]?, movieIDs: [Int]?) {
    imgPaths = url ?? imageUrls
    let idArr = movieIDs ?? []
    
//    self.imgPaths = urlArr.map { URL(string: $0) }
    self.movieIDArr = idArr
//    self.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
  }
  
  // MARK: - setupCollectionView
  private func setupCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    layout.scrollDirection = .vertical
    collectionView.backgroundColor = .black
    self.collectionView.collectionViewLayout = layout
    
    // MARK: - 컬렉션뷰 레이아웃 설정
    // 컬렉션뷰의 전체적으로 떨어진 간격 설정(inset)
    layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    // 다음줄(아랫줄)과의 간격설정 - 12
    layout.minimumLineSpacing = 12
    // 옆줄과의 간격설정 - 14
    layout.minimumInteritemSpacing = 14
    // 전체 뷰에서 왼쪽 8, 오른쪽 8, 사이 14 * 2 (전체 44)를 빼고난 나머지 공간을 3줄로 나누기
    let width = (UIScreen.main.bounds.width - 44)/3
    let height = width * 1.4380
    // 컬렉션뷰의 각 한개의 아이템 사이즈 설정
    layout.itemSize = CGSize(width: width, height: height)
    
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
    return movieIDArr.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyContentCollectionCell.identifier, for: indexPath) as! MyContentCollectionCell
    
    cell.configure(movieId: movieIDArr[indexPath.row] , imageUrlString: imgPaths[indexPath.row])
    return cell
  }
  
}
extension MyContentView: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  
        APICenter.shared.getDetailData(id: movieIDArr[indexPath.row]) { (result) in
          switch result {
          case .success(let movie):
            self.contentDelegate?.didSelectItemAt(movieId: movie.id, movieInfo: movie)
    
          case .failure(let err):
            dump(err)
            print("fail to login, reason: ", err)
    
            let message = """
            죄송합니다. 해당 영화에 대한 정보를 가져오지
            못했습니다. 다시 시도해 주세요.
            """
            let okMessage = "재시도"
    
            self.contentDelegate?.errOccurSendingAlert(message: message, okMessage: okMessage)
          }
        }
  }
}
  
  extension MyContentView: MyContentViewDelegate {
  
    func scrollViewDidScroll(scrollView: UIScrollView) {
      delegate?.scrollViewDidScroll(scrollView: scrollView)
    }
  }
