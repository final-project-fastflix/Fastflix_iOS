//
//  MainView.swift
//  TestPreview
//
//  Created by hyeoktae kwon on 2019/08/15.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class MainView: UIView {

  lazy var testStackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: views)
    view.axis = .horizontal
    view.distribution = .equalSpacing
    view.alignment = .leading
    view.spacing = 0
    view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3)
    return view
  }()
  
  lazy var flow: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    layout.itemSize = CGSize(width: width, height: height)
    
//    layout.sectionHeadersPinToVisibleBounds = true
    return layout
  }()
  
  lazy var testCollectionView: UICollectionView = {
    let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
    collection.isPagingEnabled = true
    collection.showsHorizontalScrollIndicator = false
    collection.dataSource = self
    collection.delegate = self
    return collection
  }()
  
  let disMissBtn: UIButton = {
    let btn = UIButton()
    btn.setTitle("X", for: .normal)
    btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    btn.titleLabel?.textAlignment = .center
    return btn
  }()
  
  let width = UIScreen.main.bounds.width / 3
  
  var view1 = UIImageView()
  var view2 = UIImageView()
  var view3 = UIImageView()
  var view4 = UIImageView()
  var view5 = UIImageView()
  
  lazy var views: [UIView] = [view1, view2, view3, view4, view5]
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    registerCells()
    addSubviews()
    setImage()
    setupSNP()
    setupStackView()
    testStackView.distribution = .equalSpacing
  }
  
  private func setupStackView() {
    view1.alpha = 0
    view1.snp.makeConstraints {
      $0.leading.top.bottom.equalToSuperview()
      $0.trailing.equalTo(view2.snp.leading)
      $0.width.equalToSuperview().multipliedBy(0)
    }
    
    view2.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalTo(view1.snp.trailing)
      $0.trailing.equalTo(view3.snp.leading)
      $0.width.equalToSuperview().multipliedBy(0.4)
    }
    
    view3.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalTo(view2.snp.trailing)
      $0.trailing.equalTo(view4.snp.leading)
      $0.width.equalToSuperview().multipliedBy(0.2)
    }
    
    view4.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalTo(view3.snp.trailing)
      $0.trailing.equalTo(view5.snp.leading)
      $0.width.equalToSuperview().multipliedBy(0.2)
    }
    
    view5.alpha = 0
    view5.snp.makeConstraints {
      $0.top.bottom.trailing.equalToSuperview()
      $0.leading.equalTo(view4.snp.trailing)
      $0.width.equalToSuperview().multipliedBy(0.1)
    }
  }
  
  private func setImage() {
    views.forEach { ($0 as! UIImageView).image = UIImage(named: "fastflix")
      ($0 as! UIImageView).contentMode = .scaleAspectFit
    }
  }
  
  private func registerCells() {
    testCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
  }
  
  private func addSubviews() {
    [testCollectionView, testStackView, disMissBtn].forEach { addSubview($0) }
  }
  
  private func setupSNP() {
    testCollectionView.snp.makeConstraints {
      $0.top.leading.bottom.trailing.equalToSuperview()
    }
    
    testStackView.snp.makeConstraints {
      $0.top.leading.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.2)
      $0.trailing.equalTo(disMissBtn.snp.leading)
    }
    
    disMissBtn.snp.makeConstraints {
      $0.centerY.equalTo(testStackView.snp.centerY)
      $0.trailing.equalToSuperview()
      $0.width.height.equalToSuperview().multipliedBy(0.1)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("Deinit now")
  }
}

extension MainView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return views.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    print("run")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath)
    
    return cell
  }
  
  
}

extension MainView: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentPage = (scrollView.contentOffset.x / self.frame.width)
//    print("currentPage: ", currentPage)
    print("offset", currentPage)
  }
}
