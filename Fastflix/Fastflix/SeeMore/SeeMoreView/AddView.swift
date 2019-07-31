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
    button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .light)
    button.titleLabel?.textAlignment = .center
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    button.clipsToBounds = true
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    return button
  }()
  
  lazy var profileButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("프로필추가", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .medium)
    button.titleLabel?.textAlignment = .center
    button.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
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
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    addProfileButton.layer.cornerRadius = addProfileButton.frame.width / 2
  }
  
  // 버튼에 제스쳐 넣어서 더 잘 눌리도록
  private func setupTapGesture() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
    tap.numberOfTapsRequired = 1
    tap.numberOfTouchesRequired = 1
    addProfileButton.addGestureRecognizer(tap)
    addProfileButton.isUserInteractionEnabled = true
  }
  
  // MARK: - 프로필 추가 눌렀을 시에 델리게이트를 통해 SeeMoreView로 전달
  @objc private func buttonTapped() {
    delegate?.addProfileButtonTapped()
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
      $0.top.equalTo(addProfileButton.snp.bottom).offset(10)
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(10)
    }
  }
}
