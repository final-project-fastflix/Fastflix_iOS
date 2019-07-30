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

class ProfileView: UIView {

  
  let profileImageBtn: UIButton = {
    let imageButton = UIButton(type: .custom)
    return imageButton
  }()
  
  let profileNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = UIFont.boldSystemFont(ofSize: 10)
    label.textAlignment = .center
    return label
  }()
  
  func configure(image: UIImage?, name: String?) {
    profileNameLabel.text = name ?? "프로필 추가"
    let newImg = image ?? UIImage(named: "profileAdd")
    profileImageBtn.setImage(newImg, for: .normal)
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addsubviews()
    setupSNP()
  }
  
  private func addsubviews() {
    [profileImageBtn, profileNameLabel].forEach { addSubview($0) }
  }
  
  private func setupSNP() {
    profileImageBtn.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalToSuperview().offset(15)
      $0.height.width.equalTo(60)
    }
    
    profileNameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageBtn.snp.bottom).offset(10)
      $0.bottom.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
  }

}
