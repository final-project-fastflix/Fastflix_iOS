//
//  AddProfileView.swift
//  Fastflix
//
//  Created by HongWeonpyo on 24/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

protocol AddProfileViewDelegate: class {
  func addProfileButtonTapped()
}

class AddProfileView: UIView {

  lazy var addProfileButton: UIButton = {
    let button = UIButton()
    button.setTitle("+", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 50, weight: .medium)
    button.titleLabel?.textAlignment = .center
    button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 18, right: 15)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    button.clipsToBounds = true
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    return button
  }()
  
  lazy var profileButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("프로필추가", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    button.titleLabel?.textAlignment = .center
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    return button
  }()
  
  weak var delegate: AddProfileViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubViews()
    setupSNP()
    setupTapGesture()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    addProfileButton.layer.cornerRadius = addProfileButton.frame.width / 2
  }
  
  private func setupTapGesture() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
    addProfileButton.addGestureRecognizer(tap)
    addProfileButton.isUserInteractionEnabled = true
  }
  
  
  @objc private func buttonTapped() {
    delegate?.addProfileButtonTapped()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addSubViews() {
    [addProfileButton, profileButton].forEach { self.addSubview($0) }
  }
  
  private func setupSNP(){
    addProfileButton.snp.makeConstraints {
      $0.top.equalTo(self.snp.top).offset(20)
      $0.leading.equalTo(self.snp.leading).offset(20)
      $0.trailing.equalTo(self.snp.trailing).offset(-20)
      $0.height.equalTo(self.addProfileButton.snp.width)
    }
    
    profileButton.snp.makeConstraints {
      $0.top.equalTo(addProfileButton.snp.bottom).offset(30)
      $0.leading.equalTo(self.snp.leading)
      $0.trailing.equalTo(self.snp.trailing)
      $0.height.equalTo(18)
      $0.bottom.equalTo(self.snp.bottom)
    }
  }
}
