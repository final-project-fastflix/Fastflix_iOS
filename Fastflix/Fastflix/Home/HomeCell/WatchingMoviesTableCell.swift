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
  
  private let playSlider: UISlider = {
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
    
  }
  
  func configure(url: [String]?, title: String?, time: String?) {
    let urlArr = url ?? imageUrls
    let title = title ?? "title"
    let time = time ?? "time"
    
    
    self.titleLabel.text = title
    self.playTimeLabel.text = time
    self.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
  }
  
  private func addSubViews() {
    [titleLabel, collectionView, bottomView, playSlider]
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
    playSlider.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
    }
    
    bottomView.snp.makeConstraints {
      $0.top.equalTo(playSlider.snp.bottom)
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
  
  private func setupCollectionView() {
    
  }
  
  @objc func infoBtnDidTap(_ sender: UIButton) {
    
  }
  
  
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  

}
