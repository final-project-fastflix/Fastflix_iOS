//
//  PreViewPlayerView.swift
//  Fastflix
//
//  Created by Jeon-heaji on 05/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit

class PreViewPlayerView: UIView {
  
  // MARK: - collectionView
  private let layout = UICollectionViewFlowLayout()
  
  lazy var logoCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()
  
  lazy var playCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
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
    button.setImage(UIImage(named: "play2"), for: .normal)
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
  
  let img = ["test1", "test2", "test3", "test4"]
  

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    addSubViews()
    setupSNP()
    setupCollectionView()
    registerCollectionCell()
    
  }
  
  private func addSubViews() {
    
    [logoCollectionView, playCollectionView, stackView].forEach {
      self.addSubview($0)
    }
    
  }
  private func setupSNP() {
    logoCollectionView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }
    
    playCollectionView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    stackView.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-20)
      $0.centerX.equalToSuperview()
    }
    
    
    
    
  }
  private func setupCollectionView() {
    logoCollectionView.dataSource = self
    logoCollectionView.delegate = self
    
    playCollectionView.dataSource = self
    playCollectionView.delegate = self
    
    layout.scrollDirection = .horizontal
    self.logoCollectionView.collectionViewLayout = layout
    self.playCollectionView.collectionViewLayout = layout
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    layout.minimumLineSpacing = 0

    layout.minimumInteritemSpacing = 0
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    layout.itemSize = CGSize(width: width, height: height)
    
    layout.sectionHeadersPinToVisibleBounds = true
    playCollectionView.showsHorizontalScrollIndicator = false
    
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
  
  
  
  private func registerCollectionCell() {
    logoCollectionView.register(LogoCollectionCell.self, forCellWithReuseIdentifier: LogoCollectionCell.identifier)
    playCollectionView.register(PlayCollectionViewCell.self, forCellWithReuseIdentifier: PlayCollectionViewCell.identifier)

  }

}

extension PreViewPlayerView : UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.logoCollectionView {
      return 1
    } else {
      return img.count
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = UICollectionViewCell()
    
    if collectionView == self.logoCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogoCollectionCell.identifier, for: indexPath) as! LogoCollectionCell
      cell.logoImageView.image = UIImage(named: "preViewLogo")
      
      return cell
      
    } else if collectionView == self.playCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayCollectionViewCell.identifier, for: indexPath) as! PlayCollectionViewCell

      cell.playView.image = UIImage(named: img[indexPath.row])
      return cell
    }
    
    return cell
  
  }
}

extension PreViewPlayerView: UICollectionViewDelegate {
  
}
