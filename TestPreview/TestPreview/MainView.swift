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
    view.distribution = .fill
    view.spacing = 5
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
    let collection = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flow)
    collection.isPagingEnabled = true
    collection.showsHorizontalScrollIndicator = false
    collection.dataSource = self
    collection.delegate = self
    return collection
  }()
  
  let view1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
  let view2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 150))
  let view3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 150))
  let view4 = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
  
  lazy var views: [UIView] = [view1, view2, view3, view4]
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setImage()
    registerCells()
    addSubviews()
//    testStackView.distribution = .fill
//    testStackView.autoresizesSubviews = true
//    testStackView.alignment = .fill
//    testStackView.increaseSize(nil)
//    testStackView.systemLayoutSizeFitting(CGSize(width: 200, height: 100))
//    setupSNP()
  }
  
  private func setImage() {
    views.forEach { ($0 as! UIImageView).image = UIImage(named: "fastflix")
      ($0 as! UIImageView).contentMode = .scaleAspectFit
    }
    views[0].frame = CGRect(x: 0, y: 0, width: 200, height: 150)
  }
  
  private func registerCells() {
    testCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
  }
  
  private func addSubviews() {
    [testCollectionView, testStackView].forEach { addSubview($0) }
  }
  
  private func setupSNP() {
    testCollectionView.snp.makeConstraints {
      $0.top.leading.bottom.trailing.equalToSuperview()
    }
    
    testStackView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.2)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    let currentPage = round(scrollView.contentOffset.x / self.frame.width)
//    print("currentPage: ", currentPage)
    print("offset", scrollView.contentOffset)
  }
}
