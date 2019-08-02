//
//  WatchingMoviesTableCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 01/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class WatchingMoviesTableCell: UITableViewCell {
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "hea 님이 시청중인 콘텐츠"
    label.textColor = .white
    return label
  }()
  
  private let layout = UICollectionViewFlowLayout()
  
  lazy private var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()
  
  private let bottomView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()
  
  private let infoBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "info"), for: .normal)
    button.addTarget(self, action: #selector(infoBtnDidTap(_:)), for: .touchUpInside)
    return button
  }()
  

  private let playTimeLabel: UILabel = {
    let label = UILabel()
    label.text = "2시간 5분"
    label.textColor = .gray
    return label
  }()
  
  private var progressBar: UISlider = {
    let slider = UISlider()
    slider.tintColor = .red
    slider.thumbTintColor = .red
    return slider
  }()
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubViews()
    setupSNP()
    setupCollectionView()
    registerCollectionViewCell()
    
    
  }
  
  func configure(url: [String]?, title: String?, time: String?, progress: UISlider?) {
    let urlArr = url ?? imageUrls
    let title = title ?? "title"
    let time = time ?? "time"
    var progress = progress ?? UISlider()
    
    
    self.titleLabel.text = title
    self.playTimeLabel.text = time
    self.progressBar = progress
    self.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
  }
  
  private func addSubViews() {
    [titleLabel, collectionView, bottomView, progressBar]
      .forEach { self.addSubview($0) }
    [playTimeLabel, infoBtn, ].forEach {
      self.addSubview($0)
    }
    
  }
  
  private func setupSNP() {
    titleLabel.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.height * 0.11)
    }
    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(15)
      $0.leading.trailing.equalToSuperview()
    }
    progressBar.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
    }
    
    bottomView.snp.makeConstraints {
      $0.top.equalTo(progressBar.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    playTimeLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().inset(15)
    }
    
    infoBtn.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().inset(15)
    }
    
    
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
    let height = width * 1.4
    // 컬렉션뷰의 각 한개의 아이템 사이즈 설정
    layout.itemSize = CGSize(width: width, height: height)
    
    layout.sectionHeadersPinToVisibleBounds = true
    collectionView.showsHorizontalScrollIndicator = false
    
  }
  
  // registerCollectionView
  private func registerCollectionViewCell() {
    collectionView.register(WatchingMoviesCollectionCell.self, forCellWithReuseIdentifier: WatchingMoviesCollectionCell.identifier)
  }
  
  
  
  
  @objc func infoBtnDidTap(_ sender: UIButton) {
    
  }
  
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
 
}

extension WatchingMoviesTableCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ImagesData.shared.myContentImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatchingMoviesCollectionCell.identifier, for: indexPath) as! WatchingMoviesCollectionCell
    cell.configure(imageUrlString: ImagesData.shared.myContentImages[indexPath.row])
    return cell
  }
  
  
}

extension WatchingMoviesTableCell: UICollectionViewDelegate {
  
}
