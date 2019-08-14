//
//  LoginVC.swift
//  Fastflix
//
//  Created by HongWeonpyo on 20/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

final class LoginVC: UIViewController {
  
  private let subUserSingle = SubUserSingleton.shared
  private let rootView = LoginView()
  
  
  override func loadView() {
    view = rootView
  }
  
  
  // 스태터스바 글씨 하얗게 설정
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  

  // MARK: - 시점 viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    rootView.customerCenterButton.addTarget(self, action: #selector(customerCenterTapped(_:)), for: .touchUpInside)
    rootView.backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    rootView.bigBackButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    rootView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    rootView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    rootView.passwordSecureButton.addTarget(self, action: #selector(passwordSecureModeSetting), for: .touchUpInside)
    rootView.loginButton.addTarget(self, action: #selector(didTapLoginBtn(_:)), for: .touchUpInside)
    
    configure()
    navigationBarSetting()
    setupNotiObserverForKeyboardMoveUpDown()
  }
  
  private func configure() {
    rootView.emailTextField.delegate = self
    rootView.passwordTextField.delegate = self
  }
  
  // 네비게이션바 세팅
  private func navigationBarSetting() {
    let navCon = navigationController!
    navCon.isNavigationBarHidden = true
  }
  
  
  // MARK: - 키보드 Notification
  private func setupNotiObserverForKeyboardMoveUpDown() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didReceiveKeyboardNotification(_:)),
      // 키보드가 보이기전의 노티
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didReceiveKeyboardNotification(_:)),
      // 키보드가 사라지기전의 노티
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  // MARK: - 키보드가 가리는 부분 만큼만 살짝 뷰를 올리기 위한 메서드
  @objc private func didReceiveKeyboardNotification(_ noti: Notification) {
    guard let userInfo = noti.userInfo,
      let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
      else { return }
    
    // 겹치는 영역 계산 ---> 키보드가 올라와서 스택뷰와 겹치는 영역만큼(영역 조금늘리기 위해서 플러스 + 10)
    // (다만 0보다 작을땐) 7,8과 같은 환경 (겹치는 영역이 없을땐) 안 움직이게
    let overlappedHeight = (textViewHeight*3 + 36 + 10)/2 - (self.view.frame.height/2 - keyboardFrame.height)
    
    // 기기에 따라서 실제 이동해야만 하는 높이
    var actuallyHaveToBeMovedHeight: CGFloat
    
    // 겹치는 부분이 0보다 크면 이동, 겹치는 부분이 0보다 작으면(겹치는 부분이 없으면) 즉, 0이면 이동 안함
    if overlappedHeight >= 0 {
      actuallyHaveToBeMovedHeight = overlappedHeight
    }else {
      actuallyHaveToBeMovedHeight = 0
    }
    
    // 키보드와 뷰의 조건에 따라 오토레이아웃 바꾸기
    if keyboardFrame.minY >= self.view.frame.maxY {
      // 스택뷰의 오토레이아웃 업데이트
      self.stackView.snp.updateConstraints {
        $0.centerY.equalToSuperview()
      }
      // 레이아웃 변경이 필요해
      self.stackView.setNeedsLayout()
    }else {
      // 스택뷰의 오토레이아웃 업데이트
      self.stackView.snp.updateConstraints {
          $0.centerY.equalToSuperview().offset(-actuallyHaveToBeMovedHeight)
      }
      // 레이아웃 변경이 필요해
      self.stackView.setNeedsLayout()
    }
    // 오토레이아웃 업데이트 메서드
    super.updateViewConstraints()
    
    // 실제 레이아웃 변경은 애니메이션으로 줄꺼야
    UIView.animate(withDuration: duration*2) {
      self.view.layoutIfNeeded()
    }

  }
  
  // MARK: - 비밀번호 가리기 모드 켜고 끄기
  @objc private func passwordSecureModeSetting() {
    passwordTextField.isSecureTextEntry.toggle()
  }
  
  // MARK: - 로그인버튼 눌렀을 때의 동작
  @objc private func didTapLoginBtn(_ sender: UIButton) {
    guard let id = emailTextField.text, let pw = passwordTextField.text else { return }
    
    APICenter.shared.login(id: id, pw: pw) {
      switch $0 {
      case .success(let subUsers):
        print("Login Success!!!")
        print("value: ", subUsers)
        // 로그인 성공하면 서브유저리스트를 싱글톤에 저장
        self.subUserSingle.subUserList = subUsers
        
        // 로그인 실행(서브유저 선택하면으로 이동)
        DispatchQueue.main.async {
          self.executeLogIn()
        }
      case .failure(let err):
        print("fail to login, reason: ", err)
        let message = """
        죄송합니다. 이 이메일주소를 사용하는 계정을
        찾을 수 없거나 비밀번호를 틀리셨습니다.
        다시 입력하세요.
        """
        self.oneAlert(title: "로그인", message: message, okButton: "다시 입력하기")
      }
    }
  }
  
  // MARK: - 로그인실행 서브유저선택하는 화면으로
  private func executeLogIn() {
    
    let profileSelectVC = ProfileSelectVC()
    let navi = UINavigationController(rootViewController: profileSelectVC)
    
    self.present(navi, animated: false)
  }
  
  // 고객센터버튼 눌렀을 때
  @objc private func customerCenterTapped(_ sender: UIButton) {
    let customerCenterVC = CustomerCenterVC()
    present(customerCenterVC, animated: true)
  }
  
  // 뒤로가기 버튼을 눌렀을 때
  @objc private func backButtonTapped(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: - 이메일텍스트필드, 비밀번호 텍스트필드 두가지 다 채워져 있을때, 로그인 버튼 빨간색으로 변경
  @objc private func textFieldEditingChanged(_ textField: UITextField) {
    if textField.text?.count == 1 {
      if textField.text?.first == " " {
        textField.text = ""
        return
      }
    }
    guard
      let email = emailTextField.text, !email.isEmpty,
      let password = passwordTextField.text, !password.isEmpty
      else {
        loginButton.backgroundColor = .clear
        loginButton.isEnabled = false
        return
    }
    loginButton.backgroundColor = .red
    loginButton.isEnabled = true
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
}

// MARK: - 텍스트필드 관련 델리게이트 구현
extension LoginVC: UITextFieldDelegate {
  
  // MARK: - 텍스트필드 편집 시작할때의 설정 - 문구가 위로올라가면서 크기 작아지고, 오토레이아웃 업데이트
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
    if textField == emailTextField {
      emailTextFieldView.backgroundColor = #colorLiteral(red: 0.2972877622, green: 0.2973434925, blue: 0.297280401, alpha: 1)
      emailLabel.font = UIFont.systemFont(ofSize: 11)
      // 오토레이아웃 업데이트
      emailLabel.snp.updateConstraints {
        $0.centerY.equalToSuperview().offset(-13)
      }
      // 레이아웃 변경이 필요해
      emailLabel.setNeedsLayout()
    }
    if textField == passwordTextField {
      passwordTextFieldView.backgroundColor = #colorLiteral(red: 0.2972877622, green: 0.2973434925, blue: 0.297280401, alpha: 1)
      passwordLabel.font = UIFont.systemFont(ofSize: 11)
      // 오토레이아웃 업데이트
      passwordLabel.snp.updateConstraints {
        $0.centerY.equalToSuperview().offset(-13)
      }
      // 레이아웃 변경이 필요해
      passwordLabel.setNeedsLayout()
    }
    
    // 오토레이아웃 업데이트 했어
    super.updateViewConstraints()
  
    // 실제 레이아웃 변경은 애니메이션으로 줄꺼야
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  // 텍스트필드 편집 종료되면 백그라운드 색 변경 (글자가 한개도 입력 안되었을때는 되돌리기)
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    if textField == emailTextField {
      emailTextFieldView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
      if emailTextField.text == "" {
        emailLabel.font = UIFont.systemFont(ofSize: 18)
        emailLabel.snp.updateConstraints {
          $0.centerY.equalToSuperview()
        }
        emailLabel.setNeedsLayout()
      }
    }
    if textField == passwordTextField {
      passwordTextFieldView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
      if passwordTextField.text == "" {
        passwordLabel.font = UIFont.systemFont(ofSize: 18)
        passwordLabel.snp.updateConstraints {
          $0.centerY.equalToSuperview()
        }
        passwordLabel.setNeedsLayout()
      }
    }
    super.updateViewConstraints()
  
    // 실제 레이아웃 변경은 애니메이션으로 줄꺼야
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  // 엔터 누르면 일단 키보드 내림
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}





