//
//  WatchingMoviesCollectionCell.swift
//  Fastflix
//
//  Created by Jeon-heaji on 01/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class WatchingMoviesCollectionCell: UICollectionViewCell {
 
  static let identifier = "WatchingMoviesCollectionCell"
  
  var movieID: Int? = nil
  var progressBarPoint: Float = 0
  var toBeContinue: Int? = nil
  var videoPath: String? = nil
  var runningTime: Int? = nil
  
  private lazy var imageView: UIImageView = {
    let img = UIImageView()
    img.contentMode = .scaleAspectFill
    img.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    img.clipsToBounds = true
//    img.addSubview(playImageView)
    return img
  }()
  
  // 버튼이 셀 위로 가면 셀 자체가 안 눌리는 현상이 있어서... 이미지뷰로 대체
//  var playBtn: UIButton = {
//    let button = UIButton(type: .custom)
//    button.setImage(UIImage(named: "blurplayBtn"), for: .normal)
//    button.addTarget(self, action: #selector(playBtnDidTap(_:)), for: .touchUpInside)
////    button.alpha = 0.7
//    return button
//  }()
  
  private let playImageView: UIImageView = {
    let imageview = UIImageView()
    let image = UIImage(named: "blurplayBtn")
    imageview.image = image
    return imageview
  }()
  
  
  private let bottomView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    return view
  }()
  
  private let infoBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "info"), for: .normal)
    button.addTarget(self, action: #selector(infoBtnDidTap), for: .touchUpInside)
    button.tintColor = .gray
    return button
  }()
  
  
  private let playTimeLabel: UILabel = {
    let label = UILabel()
//    label.text = "2시간 5분"
    label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    label.textColor = .gray
    return label
  }()
  
  lazy var progressBar: UISlider = {
    
    let slider = UISlider()
    slider.tintColor = .red
    slider.thumbTintColor = .clear
//    slider.thumbRect(forBounds: CGRect, trackRect: <#T##CGRect#>, value: <#T##Float#>)
    return slider
  }()
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
    addSubViews()
    setupSNP()
    setupTapGestureForView()
  }
  
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    self.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)
//    addSubViews()
//    setupSNP()
//  }
  
//  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
  
  func configure(imageUrl: String, id: Int, video: String, runningTime: Int, progress: Int, toBe: Int) {
    //이미지 설정
    imageView.kf.setImage(with: URL(string: imageUrl), options: [.processor(CroppingImageProcessor(size: CGSize(width: 170, height: 300))), .scaleFactor(UIScreen.main.scale)])
    
    self.movieID = id
    
    self.videoPath = video
    self.toBeContinue = toBe
  
    // 슬라이더 설정을 위한 값 (예) 0.333555
    let sliderFloat = Float(toBe) / Float(runningTime)
    
    // 시간(분)을 시간 기준으로 환산
    let hour = runningTime / 60
    let minute = runningTime % 60
    
    // 프로그레스바 설정
    self.progressBar.setValue(sliderFloat, animated: false)
    self.progressBarPoint = sliderFloat
    
    // 시간 String값으로 만들기
    self.playTimeLabel.text = "\(hour)시간 \(minute)분"
  }
  
  private func addSubViews() {
    [imageView, /*playBtn,*/ playImageView, progressBar, bottomView].forEach { addSubview($0) }
    [playTimeLabel, infoBtn].forEach { bottomView.addSubview($0) }
  }
  
  private func setupSNP() {
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(-30)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo((UIScreen.main.bounds.width - 50)/3 * 1.6)
    }
//    playBtn.snp.makeConstraints {
//      $0.centerX.equalToSuperview()
//      $0.centerY.equalToSuperview().offset(-5)
//    }
    
    playImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-5)
    }

    progressBar.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(-15)
      $0.leading.trailing.equalToSuperview()
    }

    bottomView.snp.makeConstraints {
      $0.top.equalTo(progressBar.snp.bottom).offset(-10)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.height * 0.1)
    }

    playTimeLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(7)
      $0.leading.equalToSuperview().inset(8)
    }

    infoBtn.snp.makeConstraints {
      $0.top.equalToSuperview().offset(5)
      $0.trailing.equalToSuperview().inset(10)
    }
  }
  
//  @objc func playBtnDidTap(_ sender: UIButton) {
//    print("playBtnDidTap Tap")
//
//  }
  
  
  @objc func infoBtnDidTap() {
    print("infoButton Did Tap")
    
//    movieID
    
  }
  
  private func setupTapGestureForView() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(infoBtnDidTap))
    tap.numberOfTapsRequired = 1
    bottomView.addGestureRecognizer(tap)
    bottomView.isUserInteractionEnabled = true
  }
  
  
  
}
