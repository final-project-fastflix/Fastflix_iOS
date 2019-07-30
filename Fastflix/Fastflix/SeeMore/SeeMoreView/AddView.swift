//
//  AddView.swift
//  Fastflix
//
//  Created by HongWeonpyo on 31/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

protocol AddViewDelegate: class {
  func addProfileButtonTapped()
}

class AddView: UIView {
  
  lazy var addProfileButton: UIButton = {
    let button = UIButton()
    button.setTitle("+", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    button.titleLabel?.textAlignment = .center
//    button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 18, right: 15)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    button.clipsToBounds = true
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    return button
  }()
  
  lazy var profileButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("프로필추가", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 8, weight: .medium)
    button.titleLabel?.textAlignment = .center
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    return button
  }()
  
  weak var delegate: AddViewDelegate?
  
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
    print("프로필추가 눌렀당")
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
      $0.top.equalToSuperview().inset(5)
      $0.centerX.equalToSuperview()
      $0.height.width.equalTo(55)
    }
    
    profileButton.snp.makeConstraints {
      $0.top.equalTo(addProfileButton.snp.bottom).offset(5)
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(10)
    }
  }
}
