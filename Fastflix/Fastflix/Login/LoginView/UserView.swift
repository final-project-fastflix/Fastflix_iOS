//
//  UserView.swift
//  Fastflix
//
//  Created by HongWeonpyo on 24/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import Kingfisher

protocol UserViewDelegate: class {
  func didSelectUser(tag: Int)
  func profileChangeTapped(tag: Int, userName: String, userImage: UIImage, imageURL: String)
  func toUserIconSelectVC()
}

class UserView: UIView {
  
  var isEditing: Bool = false {
    didSet {
      editImageView.isHidden = !isEditing
    }
  }
  
  let userImageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  var profileImage: UIImage? {
    didSet {
      userImageView.image = profileImage
    }
  }
  
  var profileUserName: String? {
    didSet {
      profileButton.setTitle(profileUserName, for: .normal)
    }
  }
  
  // 이미지경로 전달을 위한 속성
  var imagePath: String?
  
  var isForImageSelecting = false
  
  
  var editImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "pencil2")
    imageView.isHidden = true
    return imageView
  }()
  
  weak var delegate: UserViewDelegate?
  
  lazy var profileButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    button.titleLabel?.textAlignment = .center
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubViews()
    setupSNP()
    setupTapGestureForImageView()
    setupTapGestureForEditImageView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setNeedsLayout() {
    addSubViews()
    setupSNP()
  }
  
  private func setupTapGestureForImageView() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
    userImageView.addGestureRecognizer(tap)
    userImageView.isUserInteractionEnabled = true
  }
  
  private func setupTapGestureForEditImageView() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
    editImageView.addGestureRecognizer(tap)
    editImageView.isUserInteractionEnabled = true
  }
  
  private func addSubViews() {
    [userImageView, profileButton, editImageView].forEach { self.addSubview($0) }
    userImageView.addSubview(editImageView)
  }
  
  private func setupSNP(){
    userImageView.snp.makeConstraints {
      $0.top.equalTo(self.snp.top)
      $0.leading.equalTo(self.snp.leading)
      $0.trailing.equalTo(self.snp.trailing)
      $0.height.equalTo(self.userImageView.snp.width)
    }
    
    editImageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    profileButton.snp.makeConstraints {
      $0.top.equalTo(userImageView.snp.bottom).offset(10)
      $0.leading.equalTo(self.snp.leading)
      $0.trailing.equalTo(self.snp.trailing)
      $0.height.equalTo(18)
      $0.bottom.equalTo(self.snp.bottom)
    }
  }
  
  func setUserUI(userName: String) {
    profileUserName = userName
  }
  
  func configureImage(imageURLString: String?) {
    imagePath = imageURLString
    let imageURL = URL(string: imageURLString ?? "ImagesData.shared.imagesUrl[5]")
    self.userImageView.kf.setImage(with: imageURL, options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))), .scaleFactor(UIScreen.main.scale)])
  
  }
  
  @objc private func buttonTapped() {
    if isEditing {
        delegate?.profileChangeTapped(tag: tag, userName: profileUserName!, userImage: userImageView.image!, imageURL: imagePath!)
    } else {
      if isForImageSelecting {
        delegate?.toUserIconSelectVC()
      }else {
        delegate?.didSelectUser(tag: tag)
      }
    }
  }
  
}
