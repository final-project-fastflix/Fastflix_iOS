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

//protocol ProfileViewDelegate: class {
//  func didSelectUser(tag: Int)
//}

class ProfileView: UIView {

  var isSelected: Bool = false
  
  let userImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = #colorLiteral(red: 0, green: 0.9035767317, blue: 0.6621386409, alpha: 1)
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
  
//  weak var delegate: ProfileViewDelegate?
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
//    addsubviews()
//    setupSNP()
//    setupConfigure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addsubviews()
    setupSNP()
//    setupConfigure()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    print("셀렉트 되었나요?:", isSelected)
    setupConfigure()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addsubviews() {
    [userImageView, profileNameLabel].forEach { addSubview($0) }
  }
  
  private func setupSNP() {
    userImageView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalToSuperview()
      $0.height.width.equalTo(60)
    }
    
    profileNameLabel.snp.makeConstraints {
      $0.top.equalTo(userImageView.snp.bottom).offset(8)
      $0.bottom.equalToSuperview()
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
    }
  }

  func setupConfigure() {
    profileNameLabel.textColor = !isSelected ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    profileNameLabel.font = !isSelected ? UIFont.systemFont(ofSize: 11) : UIFont.boldSystemFont(ofSize: 11)
    
    if isSelected {
      userImageView.layer.borderWidth = 2
      userImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
  }
  
  func setUserUI(userName: String) {
    profileUserName = userName
  }
  
  func configureImage(imageURLString: String?) {
    let imageURL = URL(string: imageURLString ?? "ImagesData.shared.imagesUrl[5]")
    self.userImageView.kf.setImage(with: imageURL, options: [.processor(CroppingImageProcessor(size: CGSize(width: 100, height: 100))), .scaleFactor(UIScreen.main.scale)])
  }
  
//  @objc private func buttonTapped() {
//      delegate?.didSelectUser(tag: tag)
//  }
}
