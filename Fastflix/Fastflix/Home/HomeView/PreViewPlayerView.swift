//
//  PreViewPlayerView.swift
//  Fastflix
//
//  Created by Jeon-heaji on 05/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

protocol PreViewPlayerViewDelegate {
  func dismissBtnDidTap()
}

class PreViewPlayerView: UIView {
  
  var delegate: PreViewPlayerViewDelegate?
  
  //test
  let img = ["test1", "test2", "test3", "test4", "test1", "test2"]
  let logoImg = ["logoTest2", "preViewLogo", "logoTest2", "preViewLogo", "logoTest2", "preViewLogo"]
  
  // MARK: - collectionView
  private let layout = UICollectionViewFlowLayout()
  private let logoLyaout = UICollectionViewFlowLayout()
  
  lazy var logoCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: logoLyaout)
    collectionView.backgroundColor = .clear
    return collectionView
  }()
  
  lazy var playCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()
  
  lazy var logoPageController: UIPageControl = {
    let page = UIPageControl()
    //    page.currentPage = 0
    page.numberOfPages = logoImg.count
    
    page.isHidden = true
    return page
  }()
  
  lazy var playPageController: UIPageControl = {
    let page = UIPageControl()
    //    page.currentPage = 0
    page.numberOfPages = img.count
    page.isHidden = true
    return page
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
  
  private let dismissBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.addTarget(self, action: #selector(dismissBtnDidTap(_:)), for: .touchUpInside)
    button.setImage(UIImage(named: "x"), for: .normal)
    return button
  }()
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    setupStackView()
    addSubViews()
    setupSNP()
    setupCollectionView()
    registerCollectionCell()
    
    
  }
  
  private func addSubViews() {
    
    [playCollectionView, stackView, logoCollectionView, dismissBtn, logoPageController, playPageController].forEach { self.addSubview($0) }
    //    [logoCollectionView].forEach { playCollectionView.addSubview($0) }
    self.bringSubviewToFront(logoCollectionView)
    self.bringSubviewToFront(stackView)
  }
  
  private func setupSNP() {
    
    playCollectionView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    stackView.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-topPadding)
      $0.centerX.equalToSuperview()
    }
    
    logoCollectionView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.width.equalTo(UIScreen.main.bounds.width)
      $0.height.equalTo(UIScreen.main.bounds.height * 0.2)
      
    }
    
    dismissBtn.snp.makeConstraints {
      $0.top.equalToSuperview().offset(topPadding)
      $0.leading.equalTo(logoCollectionView.snp.trailing).offset(20)
      $0.trailing.equalToSuperview().offset(-5)
    }
    
    
    
  }
  
  private func registerCollectionCell() {
    logoCollectionView.register(LogoCollectionCell.self, forCellWithReuseIdentifier: LogoCollectionCell.identifier)
    playCollectionView.register(PlayCollectionViewCell.self, forCellWithReuseIdentifier: PlayCollectionViewCell.identifier)
    
  }
  private func setupCollectionView() {
    logoCollectionView.dataSource = self
    logoCollectionView.delegate = self
    
    playCollectionView.dataSource = self
    playCollectionView.delegate = self
    
    layout.scrollDirection = .horizontal
    logoLyaout.scrollDirection = .horizontal
    self.logoCollectionView.collectionViewLayout = logoLyaout
    self.playCollectionView.collectionViewLayout = layout
    
    // logo layout
    
    logoLyaout.sectionInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
    logoLyaout.minimumLineSpacing = 0
    logoLyaout.minimumInteritemSpacing = 0
    
    let w = (UIScreen.main.bounds.width)/3
    let h = w * 0.8
    // 컬렉션뷰의 각 한개의 아이템 사이즈 설정
    logoLyaout.itemSize = CGSize(width: w, height: h)
    
    logoLyaout.sectionHeadersPinToVisibleBounds = true
    logoCollectionView.showsHorizontalScrollIndicator = false
    playCollectionView.isPagingEnabled = true
    logoCollectionView.isPagingEnabled = true
    
    // Play layout
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    layout.itemSize = CGSize(width: width, height: height)
    
    layout.sectionHeadersPinToVisibleBounds = true
    playCollectionView.showsHorizontalScrollIndicator = false
    playCollectionView.clipsToBounds = false
    
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
  
  @objc private func dismissBtnDidTap(_ sender: UIButton) {
    print(" 뒤로가여 ")
    delegate?.dismissBtnDidTap()
    
  }
  
  
  
}

extension PreViewPlayerView : UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.logoCollectionView {
      return logoImg.count
    } else {
      return img.count
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView == self.logoCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogoCollectionCell.identifier, for: indexPath) as! LogoCollectionCell
      cell.logoImageView.image = UIImage(named: logoImg[indexPath.row])
      
      logoPageController.currentPage = indexPath.item
      
      return cell
      
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayCollectionViewCell.identifier, for: indexPath) as! PlayCollectionViewCell
      
      cell.playView.image = UIImage(named: img[indexPath.row])
      return cell
    }
    
  }
}

extension PreViewPlayerView: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    
    if collectionView == logoCollectionView {
      print("logo Indexpath: ", indexPath)
      logoCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    } else if collectionView == playCollectionView {
      print("play collectionView IndexPath: ", indexPath)
    }
    
  }
  
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == playCollectionView {
//      let currentPage = round(scrollView.contentOffset.x / self.frame.width)
//      let index = IndexPath(row: Int(currentPage), section: 0)
//      logoCollectionView.scrollToItem(at: index, at: .left, animated: true)
        logoCollectionView.contentOffset.x = scrollView.contentOffset.x/3
    }
    if scrollView == logoCollectionView {
        playCollectionView.contentOffset.x = scrollView.contentOffset.x * 3
//      print("logo frame: ", logoCollectionView.frame.maxX)
//      let currentPage = round((scrollView.contentOffset.x) / (logoCollectionView.frame.width))
//      print("currentPage in logo: ", currentPage)
//      let index = IndexPath(row: Int(currentPage), section: 0)
//      playCollectionView.scrollToItem(at: index, at: .left, animated: true)
    }
    
  }
}
