//
//  ProfileView.swift
//  Fastflix
//
//  Created by Jeon-heaji on 22/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

// 프로필이미지 + 프로필 이름 -> 스택뷰안에 들어갈 뷰
import UIKit
import SnapKit
import Kingfisher

protocol ProfileViewDelegate: class {
  func didSelectUser(tag: Int)
}

class ProfileView: UIView {

  var isSelected: Bool = false
  
  let userImageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
//  let profileImageBtn: UIButton = {
//    let imageButton = UIButton(type: .custom)
//    return imageButton
//  }()
  
  let profileNameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    return label
  }()
  
//  func configure(image: UIImage?, name: String?) {
//    profileNameLabel.text = name ?? "테스트"
//    let newImg = image ?? UIImage(named: "profileAdd")
//    userImageView.image = image
//  }
  
  var profileImage: UIImage? {
    didSet {
      userImageView.image = profileImage
    }
  }
  
  var profileUserName: String? {
    didSet {
      profileNameLabel.text = profileUserName
    }
  }
  
  weak var delegate: ProfileViewDelegate?
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addsubviews()
    setupSNP()
    setupConfigure()
  }
  
  private func addsubviews() {
    [userImageView, profileNameLabel].forEach { addSubview($0) }
  }
  
  private func setupSNP() {
    userImageView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalToSuperview().offset(15)
      $0.height.width.equalTo(60)
    }
    
    profileNameLabel.snp.makeConstraints {
      $0.top.equalTo(userImageView.snp.bottom).offset(10)
      $0.bottom.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
  }

  func setupConfigure() {
    profileNameLabel.textColor = !isSelected ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    profileNameLabel.font = !isSelected ? UIFont.systemFont(ofSize: 10) : UIFont.boldSystemFont(ofSize: 10)
    
    if isSelected {
      userImageView.layer.borderWidth = 2
      userImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
  }
  
  func setUserUI(userName: String) {
    profileUserName = userName ?? "테스트"
  }
  
  func configureImage(imageURLString: String?) {
    let imageURL = URL(string: imageURLString ?? "ImagesData.shared.imagesUrl[5]")
    self.userImageView.kf.setImage(with: imageURL, options: [.processor(CroppingImageProcessor(size: CGSize(width: 100, height: 100))), .scaleFactor(UIScreen.main.scale)])
  }
  
  @objc private func buttonTapped() {
      delegate?.didSelectUser(tag: tag)
  }
}
