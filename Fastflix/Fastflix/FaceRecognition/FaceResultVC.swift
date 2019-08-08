//
//  FaceResultVC.swift
//  Fastflix
//
//  Created by Jeon-heaji on 08/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher


class FaceResultVC: UIViewController {
  
   var movieId: Int? = nil
  

  
  var blurImageView: UIImageView = {
    let img = UIImageView()
    img.image = UIImage(named: "fastblur")
    img.contentMode = .scaleAspectFit
    return img
  }()
  
  lazy var blurView: UIVisualEffectView = {
    let blurView = UIVisualEffectView()
    blurView.effect = UIBlurEffect(style: .dark)
    blurView.alpha = 0.7
    return blurView
  }()
  
  let resultLabel: UILabel = {
    let label = UILabel()
    label.text = " 추천 영화 입니다! "
    label.textColor = .white
    label.backgroundColor = #colorLiteral(red: 0.7380829632, green: 0.1894473448, blue: 0.07327392331, alpha: 1)
    label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    label.textAlignment = .center
    return label
  }()
  
  
  let movieTitle: UILabel = {
    let label = UILabel()
    label.text = " 미녀와 야수 "
    label.textColor = .lightGray
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    label.textAlignment = .center
    return label
  }()
  
  let line1: UIView = {
    let line = UIView()
    line.layer.borderColor = UIColor.gray.cgColor
    line.layer.borderWidth = 1
    return line
  }()
  
  
  let movieImageView: UIImageView = {
    let movieImg = UIImageView()
    movieImg.image = UIImage(named: "283")
    movieImg.contentMode = .scaleAspectFit
    return movieImg
  }()
  
  let dismissBtn: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("뒤로가기", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.7380829632, green: 0.1894473448, blue: 0.07327392331, alpha: 1), for: .normal)
    button.addTarget(self, action: #selector(dismissBtnDidTap(_:)), for: .touchUpInside)
    button.layer.borderWidth = 0.8
    button.layer.borderColor = UIColor.gray.cgColor
    button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    return button
  }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      addSubViews()
      setupSNP()
      view.backgroundColor = #colorLiteral(red: 0.07762928299, green: 0.07762928299, blue: 0.07762928299, alpha: 1)


    }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  
  func configure(imageUrlString: String, movieName: String, movieId: Int) {
    
    movieTitle.text = movieName
    self.movieId = movieId
    
    movieImageView.kf.setImage(with: URL(string: imageUrlString), options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 200))), .cacheOriginalImage])
  }

  
  private func addSubViews() {
    [blurImageView, resultLabel, movieTitle, line1, movieImageView, dismissBtn]
      .forEach { view.addSubview($0) }
    [blurView]
      .forEach { blurImageView.addSubview($0) }
    
  }
  
  private func setupSNP() {
    blurImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.height * 0.23)
    }
    blurView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.height * 0.23)
    }
    
    resultLabel.snp.makeConstraints {
      $0.top.equalTo(blurImageView.snp.bottom).offset(-20)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(55)
      $0.width.equalTo(280)
    }
    
    movieTitle.snp.makeConstraints {
      $0.top.equalTo(resultLabel.snp.bottom).offset(30)
      $0.centerX.equalToSuperview()
    }
    
    line1.snp.makeConstraints {
      $0.top.equalTo(movieTitle.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(1)
    }
    
    movieImageView.snp.makeConstraints {
      $0.top.equalTo(line1.snp.bottom).offset(40)
      $0.height.equalTo(UIScreen.main.bounds.height * 0.35)
      $0.width.equalTo(250)
      $0.centerX.equalToSuperview()
    }
    
    dismissBtn.snp.makeConstraints {
      $0.top.equalTo(movieImageView.snp.bottom).offset(50)
      $0.height.equalTo(40)
      $0.width.equalTo(150)
      $0.centerX.equalToSuperview()
    }
    
  }
  
  @objc func dismissBtnDidTap(_ sender: UIButton) {
    dismiss(animated: true)
    
  }
  
  func configure(imageUrlString: String, movieId: Int) {
    //    searchImageView.kf.setImage(with: URL(string: imageUrlString), options: [.processor(CroppingImageProcessor(size: CGSize(width: 150, height: 200))), .scaleFactor(UIScreen.main.scale)])
    
    self.movieId = movieId
    movieImageView.kf.setImage(with: URL(string: imageUrlString), options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 200))), .cacheOriginalImage])
  }
  
  private func setupTapGestureForView() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap))
    tap.numberOfTapsRequired = 1
    movieImageView.addGestureRecognizer(tap)
    movieImageView.isUserInteractionEnabled = true
  }
  
  @objc func imageViewDidTap() {
    let id = movieId!
    
    
  }


  
}
