//
//  MainView.swift
//  TestPreview
//
//  Created by hyeoktae kwon on 2019/08/15.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class MainView: UIView {
  
  var currentPaged: CGFloat = 0
  
  var width = UIScreen.main.bounds.width - (UIScreen.main.bounds.width * 0.1)

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
      $0.top.bottom.equalToSuperview()
//      $0.width.equalToSuperview().multipliedBy(0)
      $0.width.equalTo(0)
    }
    
    view2.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
//      $0.width.equalToSuperview().multipliedBy(0.6)
      $0.width.equalTo(width * 0.5)
    }
    
    view3.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
//      $0.width.equalToSuperview().multipliedBy(0.2)
      $0.width.equalTo(width * 0.25)
    }
    
    view4.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
//      $0.width.equalToSuperview().multipliedBy(0.2)
      $0.width.equalTo(width * 0.25)
    }
    
    view5.alpha = 0
    view5.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
//      $0.width.equalToSuperview().multipliedBy(0)
      $0.width.equalTo(0)
    }
  }
  
  private func forwardScroll(value: CGFloat) {
    print("forward")
    view1.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
//      $0.width.equalToSuperview().multipliedBy(0)
      $0.width.equalTo(0)
    }
    
    view2.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
//      $0.width.equalToSuperview().multipliedBy(0.6)
      $0.width.equalTo(width * 0.5 - (value * width * 0.5))
    }
    
    view3.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
//      $0.width.equalToSuperview().multipliedBy(0.2)
      $0.width.equalTo(width * 0.25 + (value * width * 0.25))
    }
    
    view4.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
//      $0.width.equalToSuperview().multipliedBy(0.2)
      $0.width.equalTo(width * 0.25)
    }
    
    view5.alpha = value
    view5.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
//      $0.width.equalToSuperview().multipliedBy(value * 0.2)
      $0.width.equalTo(value * width * 0.25)
    }
  }
  
  private func backwardScroll(value: CGFloat) {
    print("backward")
    let absValue = abs(value)
    view1.alpha = absValue
    view1.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0)
      $0.width.equalTo(absValue * width * 0.5)
    }
    
    view2.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0.6)
      $0.width.equalTo(width * 0.5 - (absValue * width * 0.25))
    }
    
    view3.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0.2)
      $0.width.equalTo(width * 0.25)
    }
    
//    view4.alpha = 1 + value
    view4.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0.2)
      $0.width.equalTo(width * 0.25 - (absValue * width * 0.25))
    }
    
    view5.alpha = 1 - absValue
    view5.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(value * 0.2)
      $0.width.equalTo(0)
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
    let value = currentPage - currentPaged
    print("wantValue: ", value)
    
    if value > 0 {
      self.forwardScroll(value: value)
    } else if value < 0 {
      self.backwardScroll(value: value)
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let currentPage = round(scrollView.contentOffset.x / self.frame.width)
    self.stoppedScrolling(page: currentPage)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      let currentPage = round(scrollView.contentOffset.x / self.frame.width)
      self.stoppedScrolling(page: currentPage)
    }
  }
  
  func stoppedScrolling(page: CGFloat) {
    currentPaged = page
    print("Scroll finished")
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    print("finishAnimation")
  }
}
