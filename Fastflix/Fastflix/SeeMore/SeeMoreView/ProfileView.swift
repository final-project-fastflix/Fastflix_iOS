//
//  ProfileView.swift
//  Fastflix
//
//  Created by Jeon-heaji on 22/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher


protocol ProfileViewDelegate: class {
  func didSelectUser(tag: Int)
}

class ProfileView: UIView {

  // MARK: -유저가 선택되어있는 경우, 레이아웃을 다르게(흰색 테두리 및, 레이블 글씨 굴고 하얗게) 하기 위해 만든 속성
  var isSelected: Bool = false
  
  let userImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
    return imageView
  }()
  
  let profileNameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    return label
  }()
  
  // 프로파일 이미지 속성이 바뀌면 이미지뷰에 바로 적용 시킴
  var profileImage: UIImage? {
    didSet {
      userImageView.image = profileImage
    }
  }
  
  // 프로파일 유저 이름이 바뀌면 레이블에 바로 적용 시킴
  var profileUserName: String? {
    didSet {
      profileNameLabel.text = profileUserName
    }
  }
  
  weak var delegate: ProfileViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addsubviews()
    setupSNP()
    setupTapGesture()
  }
  
  // 이미지뷰를 클릭해도 버튼 효과를 위해서 탭제스쳐 올림
  private func setupTapGesture() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(profileDidTap))
    tap.numberOfTapsRequired = 1
    tap.numberOfTouchesRequired = 1
    userImageView.addGestureRecognizer(tap)
    userImageView.isUserInteractionEnabled = true
  }
  
  // 선택시 레이아웃 바꿔주기 위해, layoutSubviews에서 구현
  override func layoutSubviews() {
    super.layoutSubviews()
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

  // MARK: - 선택 여부(isSelected)에 따라 UI를 달리하기 위함
  func setupConfigure() {
    // 선택이 되어있지않다면(!isSelected), 회색에 글씨 얇게 / 선택이 되어있다면(isSelected) 글씨 굵게
    profileNameLabel.textColor = !isSelected ? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    profileNameLabel.font = !isSelected ? UIFont.systemFont(ofSize: 11) : UIFont.boldSystemFont(ofSize: 11)
    
    // 선택이 되어있다면(isSelected) 글씨 테두리 굴게 하얗게
    if isSelected {
      userImageView.layer.borderWidth = 2
      userImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }else {
      userImageView.layer.borderWidth = 0
      userImageView.layer.borderColor = .none
    }
  }
  
  // MARK: - 유저이름 설정(UI)
  func setUserUI(userName: String) {
    profileUserName = userName
  }
  
  // MARK: - 유저이미지 설정(UI)
  func configureImage(imageURLString: String?) {
    let imageURL = URL(string: imageURLString ?? "ImagesData.shared.imagesUrl[5]")
    self.userImageView.kf.setImage(with: imageURL, options: [.processor(CroppingImageProcessor(size: CGSize(width: 100, height: 100))), .scaleFactor(UIScreen.main.scale)])
  }
  
  // MARK: - 탭해서 눌렀을 때 태그를 전달(태그의 경우 SeeMoreView에서 셋업시에 "서브유저아이디"로 전달 받았음)
  @objc private func profileDidTap() {
    delegate?.didSelectUser(tag: self.tag)
  }
}
