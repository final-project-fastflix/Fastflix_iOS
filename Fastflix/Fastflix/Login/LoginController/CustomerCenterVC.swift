//
//  CustomerCenterVC.swift
//  Fastflix
//
//  Created by HongWeonpyo on 26/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class CustomerCenterVC: UIViewController {
  
  // 네이게이션뷰
  lazy var navigationView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.addSubview(logoView)
    view.addSubview(backButton)
    return view
  }()
  
  // 로고
  let logoView: UIImageView = {
    let image = UIImage(named: "fastflix")
    let view = UIImageView()
    view.image = image
    view.contentMode = .scaleToFill
    return view
  }()
  
  // 뒤로가기 버튼
  lazy var backButton: UIButton = {
    let button = UIButton(type: .system)
    let image = UIImage(named: "back")
    button.setImage(image, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.tintColor = .black
    button.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    return button
  }()
  
  // 안내문구
  let guidancelabel1: UILabel = {
    let label = UILabel()
    label.text = "찾아주셔서 감사합니다."
    label.font = UIFont.systemFont(ofSize: 20, weight: .black)
    label.textColor = .black
    label.textAlignment = .left
    return label
  }()
  
  let guidancelabel2: UILabel = {
    let label = UILabel()
    label.text = """
    앱 내에서는 Fastflix에 가입할 수 없습니다.
    번거로우시겠지만, 회원 가입 완료 후 앱을 통해 TV
    프로그램과 영화를 시청하세요
    
    이미회원이신가요?
    """
    label.font = UIFont.systemFont(ofSize: 15)
    label.numberOfLines = 5
    label.textColor = .black
    label.textAlignment = .left
    return label
  }()
  
  lazy var passwordResetButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("비밀번호 재설정", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    button.backgroundColor = .black
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 3
    button.addTarget(self, action: #selector(passwordResetButtonTapped(_:)), for: .touchUpInside)
    return button
  }()
  
  let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    return view
  }()
  
  let guidancelabel3: UILabel = {
    let label = UILabel()
    label.text = "Fastflix 고객 센터 문의"
    label.font = UIFont.systemFont(ofSize: 20, weight: .black)
    label.textColor = .black
    label.textAlignment = .left
    return label
  }()
  
  let guidancelabel4: UILabel = {
    let label = UILabel()
    label.text = "온라인 통화로 상담원과 연결해 드리겠습니다."
    label.font = UIFont.systemFont(ofSize: 15)
    label.textColor = .black
    label.textAlignment = .left
    return label
  }()
  
  lazy var customerCenterCallButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("문의 전화", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    button.backgroundColor = .black
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 3
    button.addTarget(self, action: #selector(customerCenterCallButtonTapped(_:)), for: .touchUpInside)
    return button
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    addSubViews()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupSNP()
  }
  
  private func configure() {
    view.backgroundColor = .white
  }
  
  private func addSubViews() {
    [navigationView, guidancelabel1, guidancelabel2, passwordResetButton, lineView, guidancelabel3, guidancelabel4, customerCenterCallButton].forEach { view.addSubview($0) }
  }
  
  private func setupSNP() {
    
    navigationView.snp.makeConstraints {
      $0.top.equalTo(view.snp.top)
      $0.leading.equalTo(view.snp.leading)
      $0.trailing.equalTo(view.snp.trailing)
      $0.height.equalTo(UIScreen.main.bounds.height * 0.11)
    }
    
    logoView.snp.makeConstraints {
      $0.bottom.equalTo(navigationView.snp.bottom).offset(8)
      $0.centerX.equalTo(navigationView.snp.centerX)
      $0.width.equalToSuperview().multipliedBy(0.25)
      $0.height.equalTo(logoView.snp.width).multipliedBy(0.70)
    }
    
    backButton.snp.makeConstraints {
      $0.centerY.equalTo(logoView.snp.centerY)
      $0.width.height.equalTo(20)
      $0.leading.equalTo(view.snp.leading).offset(15)
    }
    
    guidancelabel1.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom).offset(30)
      $0.leading.equalTo(view.snp.leading).offset(15)
    }
    
    guidancelabel2.snp.makeConstraints {
      $0.top.equalTo(guidancelabel1.snp.bottom).offset(20)
      $0.leading.equalTo(view.snp.leading).offset(15)
    }
    
    passwordResetButton.snp.makeConstraints {
      $0.top.equalTo(guidancelabel2.snp.bottom).offset(20)
      $0.leading.equalTo(view.snp.leading).offset(15)
      $0.width.equalTo(150)
      $0.height.equalTo(35)
    }
    
    lineView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.top.equalTo(passwordResetButton.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(15)
    }
    
    guidancelabel3.snp.makeConstraints {
      $0.top.equalTo(lineView.snp.bottom).offset(20)
      $0.leading.equalTo(view.snp.leading).offset(15)
    }
    
    guidancelabel4.snp.makeConstraints {
      $0.top.equalTo(guidancelabel3.snp.bottom).offset(20)
      $0.leading.equalTo(view.snp.leading).offset(15)
    }
    
    customerCenterCallButton.snp.makeConstraints {
      $0.top.equalTo(guidancelabel4.snp.bottom).offset(20)
      $0.leading.equalTo(view.snp.leading).offset(15)
      $0.width.equalTo(110)
      $0.height.equalTo(35)
    }
    
    
  }
  
  @objc private func backButtonTapped(_ sender: UIButton) {
    dismiss(animated: true)
    navigationController?.popViewController(animated: true)
  }
  
  
  @objc private func passwordResetButtonTapped(_ sender: UIButton) {
//    print("비밀번호 재설정 버튼 눌렀당")
  }
  
  
  @objc private func customerCenterCallButtonTapped(_ sender: UIButton) {
//    print("문의 전화 버튼 눌렀당")
  }
  
}
