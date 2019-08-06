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
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    return stackView
  }()

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    addSubViews()
    setupSNP()
    setupCollectionView()
    registerCollectionCell()
    
  }
  
  private func addSubViews() {
    
    [logoCollectionView, playCollectionView]
      .forEach{ self.addSubview($0) }
    
  }
  private func setupSNP() {
    logoCollectionView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
  }
  private func setupCollectionView() {
    logoCollectionView.dataSource = self
    logoCollectionView.delegate = self
    
    playCollectionView.dataSource = self
    playCollectionView.delegate = self
    
    
  }
  
  private func registerCollectionCell() {
    logoCollectionView.register(LogoCollectionCell.self, forCellWithReuseIdentifier: LogoCollectionCell.identifier)

  }

}

extension PreViewPlayerView : UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayCollectionCell.identifier, for: indexPath) as! PlayCollectionCell
    return cell
  }
}

extension PreViewPlayerView: UICollectionViewDelegate {
  
}
