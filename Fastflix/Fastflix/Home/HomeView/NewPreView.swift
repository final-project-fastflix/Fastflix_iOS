//
//  NewPreView.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/08/21.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

final class NewPreView: UIView {
  
  private var index: IndexPath?
  private var currentPaged: CGFloat = 0
  private var imgArr: [UIImage] = []
  
  private var width = UIScreen.main.bounds.width - (UIScreen.main.bounds.width * 0.1)
//  private var height = UIScreen.main.bounds.height - (UIScreen.main.bounds.height * 0.8)
  
  var mainURLs: [URL?]?
  var logoURLs: [URL?]?
  var idArr: [Int?]?
  var playerItems: [URL?]?
  
  lazy var logoStackView: UIStackView = {
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
  
  lazy var playerCollectionView: UICollectionView = {
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
  
  private lazy var pokeButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "add"), for: .normal)
    button.setImage(UIImage(named: "poke"), for: .selected)
    button.addTarget(self, action: #selector(pokeBtnDidTap(_:)), for: .touchUpInside)
    return button
  }()
  
  private let playButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "play3"), for: .normal)
    button.tintColor = .white
    return button
  }()
  
  private let infoButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "info"), for: .normal)
    button.tintColor = .white
    return button
  }()
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    return stackView
  }()
  
  var view1 = UIButton()
  var view2 = UIButton()
  var view3 = UIButton()
  var view4 = UIButton()
  var view5 = UIButton()
  
  lazy var views: [UIView] = [view1, view2, view3, view4, view5]
  
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    
//    
//  }
  
  func configure() {
    setupViews()
    makeImageArr() {
      DispatchQueue.main.async {
        self.firstRun()
      }
    }
  }
  
  private func firstRun() {
    registerCells()
    addSubviews()
    setImage(page: 0)
    setupSNP()
    setupStackView()
    setupStackViewLayout()
  }
  
  private func setupViews() {
//    view1.imageView?.contentMode = .scaleAspectFit
//    view2.imageView?.contentMode = .scaleAspectFit
//    view3.imageView?.contentMode = .scaleAspectFit
//    view4.imageView?.contentMode = .scaleAspectFit
//    view5.imageView?.contentMode = .scaleAspectFit
    
    views.forEach { ($0 as! UIButton).imageView?.contentMode = .scaleAspectFit }
    
    view2.tag = 2
    view2.addTarget(self, action: #selector(didTapViews(_:)), for: .touchUpInside)
    view3.tag = 3
    view3.addTarget(self, action: #selector(didTapViews(_:)), for: .touchUpInside)
    view4.tag = 4
    view4.addTarget(self, action: #selector(didTapViews(_:)), for: .touchUpInside)
  }
  
  @objc private func didTapViews(_ sender: UIButton) {
    switch sender.tag {
    case 2:
      print("num2")
    case 3:
      print("num3")
      playerCollectionView.scrollToItem(at: IndexPath(row: Int(currentPaged + 1), section: 0), at: .left, animated: true)
    case 4:
      print("num4")
      playerCollectionView.scrollToItem(at: IndexPath(row: Int(currentPaged + 2), section: 0), at: .left, animated: true)
    default:
      break
    }
  }
  
  private func makeImageArr(completion: @escaping () -> ()) {
    print("test begin")
    let group = DispatchGroup.init()
    
    guard let urls = logoURLs else { return }
    print("test middle")
    
      for url in urls {
        group.enter()
        do {
          let data = try Data(contentsOf: url!)
          self.imgArr.append(UIImage(data: data)!.cropAlpha())
          group.leave()
        } catch(let err) {
          print(err.localizedDescription)
          group.leave()
        }
      }
    
    
    
    group.notify(queue: .global()) {
      print("test finish", self.imgArr)
      completion()
    }
    
  }
  
  private func setupStackViewLayout() {
    
    view1.alpha = 0
    view1.snp.remakeConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0)
      $0.width.equalTo(0)
//      $0.height.equalTo(0)
    }
    
    view2.snp.remakeConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0.6)
      $0.width.equalTo(width * 0.6)
//      $0.height.equalTo(height)
    }
    
    view3.snp.remakeConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0.2)
      $0.width.equalTo(width * 0.2)
//      $0.height.equalTo(height/2)
    }
    
    view4.snp.remakeConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0.2)
      $0.width.equalTo(width * 0.2)
//      $0.height.equalTo(height/2)
    }
    
    view5.alpha = 0
    view5.snp.remakeConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0)
      $0.width.equalTo(0)
//      $0.height.equalTo(0)
    }
    setImage(page: currentPaged)
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
      $0.width.equalTo(width * 0.6 - (value * width * 0.6))
    }
    
    view3.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0.2)
      $0.width.equalTo(width * 0.2 + (value * width * 0.4))
    }
    
    view4.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0.2)
      $0.width.equalTo(width * 0.2)
    }
    
    view5.alpha = value
    view5.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(value * 0.2)
      $0.width.equalTo(value * width * 0.2)
    }
    setImage(page: currentPaged)
  }
  
  private func backwardScroll(value: CGFloat) {
    
    print("backward", currentPaged)
    let absValue = abs(value)
    view1.alpha = absValue
    view1.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0)
      $0.width.equalTo(absValue * width * 0.6)
    }
    
    view2.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0.6)
      $0.width.equalTo(width * 0.6 - (absValue * width * 0.4))
    }
    
    view3.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0.2)
      $0.width.equalTo(width * 0.2)
    }
    
    //    view4.alpha = 1 + value
    view4.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(0.2)
      $0.width.equalTo(width * 0.2 - (absValue * width * 0.2))
    }
    
    view5.alpha = 1 - absValue
    view5.snp.updateConstraints {
      $0.top.bottom.equalToSuperview()
      //      $0.width.equalToSuperview().multipliedBy(value * 0.2)
      $0.width.equalTo(0)
    }
    setImage(page: currentPaged)
  }
  
  private func setImage(page: CGFloat) {
    
    views.forEach { ($0 as! UIButton).isEnabled = true }
    let paging = Int(page)
    switch paging {
    case 0:
      view1.setImage(nil, for: .normal)
      view2.setImage(imgArr[paging], for: .normal)
      view3.setImage(imgArr[paging+1], for: .normal)
      view4.setImage(imgArr[paging+2], for: .normal)
      view5.setImage(imgArr[paging+3], for: .normal)
      view1.isEnabled = false
    case imgArr.count - 3:
      view1.setImage(imgArr[paging-1], for: .normal)
      view2.setImage(imgArr[paging], for: .normal)
      view3.setImage(imgArr[paging+1], for: .normal)
      view4.setImage(imgArr[paging+2], for: .normal)
      view5.setImage(nil, for: .normal)
      view5.isEnabled = false
    case imgArr.count - 2:
      view1.setImage(imgArr[paging-1], for: .normal)
      view2.setImage(imgArr[paging], for: .normal)
      view3.setImage(imgArr[paging+1], for: .normal)
      view4.setImage(nil, for: .normal)
      view5.setImage(nil, for: .normal)
      view4.isEnabled = false
      view5.isEnabled = false
    case imgArr.count - 1:
      view1.setImage(imgArr[paging-1], for: .normal)
      view2.setImage(imgArr[paging], for: .normal)
      view3.setImage(nil, for: .normal)
      view4.setImage(nil, for: .normal)
      view5.setImage(nil, for: .normal)
      view3.isEnabled = false
      view4.isEnabled = false
      view5.isEnabled = false
    default:
      view1.setImage(imgArr[paging-1], for: .normal)
      view2.setImage(imgArr[paging], for: .normal)
      view3.setImage(imgArr[paging+1], for: .normal)
      view4.setImage(imgArr[paging+2], for: .normal)
      view5.setImage(imgArr[paging+3], for: .normal)
    }
    
//    pageInt = page == 0 ? 1 : Int(page)
//
//    for idx in 0..<views.count {
//      print("test in setImg before guard1", pageInt, page)
//      guard pageInt != 0 else {
//        pageInt += 1
//        continue }
//      print("test in setImg before guard2", imgArr.count)
//      guard pageInt <= imgArr.count else { return }
//      (views[idx] as! UIButton).setImage(imgArr[pageInt - 1], for: .normal)
//      print("test in setImg: ", (views[idx] as! UIButton).imageView?.image)
//      pageInt += 1
//    }
    
//    views.forEach { ($0 as! UIImageView).image = UIImage(named: "fastflix")
//      ($0 as! UIImageView).contentMode = .scaleAspectFit
//    }
  }
  
  private func registerCells() {
    playerCollectionView.register(PlayCollectionViewCell.self, forCellWithReuseIdentifier: PlayCollectionViewCell.identifier)
  }
  
  private func addSubviews() {
    [playerCollectionView, logoStackView, disMissBtn, stackView].forEach { addSubview($0) }
    self.bringSubviewToFront(logoStackView)
    self.bringSubviewToFront(stackView)
    self.bringSubviewToFront(disMissBtn)
  }
  
  private func setupSNP() {
    playerCollectionView.snp.makeConstraints {
      $0.top.leading.bottom.trailing.equalToSuperview()
    }
    
    logoStackView.snp.makeConstraints {
      $0.top.leading.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.2)
      $0.trailing.equalTo(disMissBtn.snp.leading)
    }
    
    disMissBtn.snp.makeConstraints {
      $0.centerY.equalTo(logoStackView.snp.centerY)
      $0.trailing.equalToSuperview()
      $0.width.height.equalToSuperview().multipliedBy(0.1)
    }
    
    stackView.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-topPadding)
      $0.centerX.equalToSuperview()
    }
  }
  
  private func setupStackView() {
    // stackView
    stackView = UIStackView(arrangedSubviews: [pokeButton, playButton, infoButton])
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 50
  }
  
  @objc func pokeBtnDidTap(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3) {
      self.pokeButton.alpha = 0
    }
    sender.isSelected.toggle()
    UIView.animate(withDuration: 0.3) {
      self.pokeButton.alpha = 1
    }
  }
  
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
  
  deinit {
    
    guard let count = playerItems?.count else { return }
    
    for idx in 0..<count {
      let index = IndexPath(row: idx, section: 0)
      let cell = playerCollectionView.cellForItem(at: index) as? PlayCollectionViewCell
      cell?.player.pause()
      
      cell?.player.replaceCurrentItem(with: nil)
      //      cell?.player = AVPlayer()
      cell?.playerLayer?.removeAllAnimations()
      cell?.playerLayer?.removeFromSuperlayer()
    }
    print("Deinit now")
  }
}

extension NewPreView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imgArr.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    print("run")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayCollectionViewCell.identifier, for: indexPath) as! PlayCollectionViewCell
    cell.configure(item: playerItems?[indexPath.row])
    if indexPath.row == 0 {
      cell.player.play()
    }
    return cell
  }
  
  
  
}

extension NewPreView: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentPage = (scrollView.contentOffset.x / self.frame.width)
    let value = currentPage - currentPaged
    let absValue = abs(value)
    if value > 0 && absValue <= 1 {
      self.forwardScroll(value: value)
    } else if value < 0 && absValue <= 1 {
      self.backwardScroll(value: value)
    } else {
      self.setupStackView()
    }
    
    let indexArr = playerCollectionView.indexPathsForVisibleItems
    for idx in indexArr {
      let cell = playerCollectionView.cellForItem(at: idx) as? PlayCollectionViewCell
      cell?.player.pause()
    }
    
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let currentPage = ceil(scrollView.contentOffset.x / self.frame.width)
    self.stoppedScrolling(page: currentPage)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      let currentPage = ceil(scrollView.contentOffset.x / self.frame.width)
      
      self.stoppedScrolling(page: currentPage)
    }
  }
  
  func stoppedScrolling(page: CGFloat) {
    currentPaged = page
    
    let cell = playerCollectionView.cellForItem(at: IndexPath(row: Int(page), section: 0)) as? PlayCollectionViewCell
    cell?.player.play()
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    print("endAnimation")
    
    let currentPage = round(scrollView.contentOffset.x / self.frame.width)
    self.stoppedScrolling(page: currentPage)
    setImage(page: currentPaged)
    setupStackViewLayout()
    print(currentPaged)
  }
}

