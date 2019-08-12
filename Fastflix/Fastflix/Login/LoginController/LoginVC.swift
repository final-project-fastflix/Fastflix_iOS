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
  
  // 스태터스바 글씨 하얗게 설정
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // 네이게이션뷰(네비게이션 커스텀하기 위해, 뷰를 네이게이션바처럼 보이게하기 위함)
  private lazy var navigationView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.addSubview(logoView)
    view.addSubview(customerCenterButton)
    view.addSubview(backButton)
    view.addSubview(bigBackButton)
    return view
  }()
  
  // 네비게이션 - 로고
  private let logoView: UIImageView = {
    let image = UIImage(named: "fastflix")
    let view = UIImageView()
    view.image = image
    view.contentMode = .scaleToFill
    return view
  }()
  
  // 고객센터 버튼
  private lazy var customerCenterButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("고객 센터", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(customerCenterTapped(_:)), for: .touchUpInside)
    return button
  }()
  
  // 뒤로가기 버튼
  private lazy var backButton: UIButton = {
    let button = UIButton(type: .system)
    let image = UIImage(named: "back")
    button.setImage(image, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.tintColor = .white
    button.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    return button
  }()

  // 뒤로가기 잘 안눌려서 큰 버튼 위에 입힘
  private let bigBackButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = .clear
    button.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    return button
  }()
  
  // MARK: - 이메일 입력하는 텍스트 뷰 (뷰 위에 텍스트 필드 및 안내문구 올라가 있음)
  private lazy var emailTextFieldView: UIView = {
    let view = UIView()
    view.frame.size.height = 48
    view.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    view.layer.cornerRadius = 5
    view.clipsToBounds = true
    view.layer.cornerRadius = 5
    view.addSubview(emailTextField)
    view.addSubview(emailLabel)
    return view
  }()
  
  // 이메일텍스트필드의 안내문구
  private var emailLabel: UILabel = {
    let label = UILabel()
    label.text = "이메일주소 또는 전화번호"
    label.font = UIFont.systemFont(ofSize: 18)
    label.textColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    return label
  }()
  
  // 로그인 - 이메일 입력 필드
  private lazy var emailTextField: UITextField = {
    var tf = UITextField()
    tf.frame.size.height = 48
    tf.backgroundColor = .clear
    tf.textColor = .white
    tf.tintColor = .white
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    tf.spellCheckingType = .no
    tf.keyboardType = .emailAddress
    tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
//    tf.keyboardAppearance = .dark
    return tf
  }()
  
  // MARK: - 비밀번호 입력하는 텍스트 뷰 (뷰 위에 텍스트 필드 및 안내문구 올라가 있음)
  private lazy var passwordTextFieldView: UIView = {
    let view = UIView()
    view.frame.size.height = 48
    view.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    view.layer.cornerRadius = 5
    view.clipsToBounds = true
    view.layer.cornerRadius = 5
    view.addSubview(passwordTextField)
    view.addSubview(passwordLabel)
    view.addSubview(passwordSecureButton)
    return view
  }()
  
  // 패스워드텍스트필드의 안내문구
  private var passwordLabel: UILabel = {
    let label = UILabel()
    label.text = "비밀번호"
    label.font = UIFont.systemFont(ofSize: 18)
    label.textColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    return label
  }()
  
  // 로그인 - 비밀번호 입력 필드
  private let passwordTextField: UITextField = {
    let tf = UITextField()
    tf.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    tf.frame.size.height = 48
    tf.backgroundColor = .clear
    tf.textColor = .white
    tf.tintColor = .white
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    tf.spellCheckingType = .no
    tf.isSecureTextEntry = true
    tf.clearsOnBeginEditing = false
    tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
//    tf.keyboardAppearance = .dark
    return tf
  }()
  
  // 패스워드에 "표시"버튼 비밀번호 가리기 기능
  private let passwordSecureButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("표시", for: .normal)
    button.setTitleColor(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
    button.addTarget(self, action: #selector(passwordSecureModeSetting), for: .touchUpInside)
    return button
  }()
  
  // MARK: - 로그인버튼
  private let loginButton: UIButton = {
    let button = UIButton(type: .custom)
    button.backgroundColor = .clear
    button.layer.cornerRadius = 5
    button.layer.borderWidth = 1
    button.layer.borderColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    button.setTitle("로그인", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    button.addTarget(self, action: #selector(didTapLoginBtn(_:)), for: .touchUpInside)
    button.isEnabled = false
    return button
  }()
  
  // 이메일텍스트필드, 패스워드, 로그인버튼 스택뷰에 배치
  private lazy var stackView: UIStackView = {
    let sview = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView, loginButton])
    sview.spacing = 18
    sview.axis = .vertical
    sview.distribution = .equalSpacing
    sview.alignment = .fill
    return sview
  }()
  
  // 비밀번호 재설정 버튼
  private let passwordResetButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .clear
    button.setTitle("비밀번호 재설정", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    return button
  }()
  
  // 3개의 각 텍스트필드 및 로그인 버튼의 높이 설정
  private let textViewHeight: CGFloat = 48

  // MARK: - 시점 viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
    navigationBarSetting()
    addSubViews()
    setupSNP()
    setupNotiObserverForKeyboardMoveUpDown()
  }
  
  private func configure() {
    view.backgroundColor = #colorLiteral(red: 0.07450980392, green: 0.07450980392, blue: 0.07450980392, alpha: 1)
    emailTextField.delegate = self
    passwordTextField.delegate = self
  }
  
  // 네비게이션바 세팅
  private func navigationBarSetting() {
    let navCon = navigationController!
    navCon.isNavigationBarHidden = true
  }
  
  private func addSubViews() {
    [navigationView, stackView, passwordResetButton].forEach { view.addSubview($0)}
  }
  
  private func setupSNP() {
    
    navigationView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.height * 0.11)
    }
    logoView.snp.makeConstraints {
      $0.bottom.equalTo(navigationView.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.25)
      $0.height.equalTo(logoView.snp.width).multipliedBy(0.70)
    }
    
    customerCenterButton.snp.makeConstraints {
      $0.centerY.equalTo(logoView.snp.centerY)
      $0.trailing.equalTo(view.snp.trailing).offset(-15)
    }
    
    backButton.snp.makeConstraints {
      $0.centerY.equalTo(logoView.snp.centerY)
      $0.width.height.equalTo(14)
      $0.leading.equalTo(view.snp.leading).offset(20)
    }
    
    bigBackButton.snp.makeConstraints {
      $0.centerX.centerY.equalTo(backButton)
      $0.width.height.equalTo(30)
    }
  
    emailLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(8)
      $0.centerY.equalToSuperview()
    }
    
    emailTextField.snp.makeConstraints {
      $0.top.equalToSuperview().inset(15)
      $0.bottom.equalToSuperview().inset(2)
      $0.leading.trailing.equalToSuperview().inset(8)
    }
    
    passwordLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(8)
      $0.centerY.equalToSuperview()
    }
    
    passwordTextField.snp.makeConstraints {
      $0.top.equalToSuperview().inset(15)
      $0.bottom.equalToSuperview().inset(2)
      $0.leading.trailing.equalToSuperview().inset(8)
    }
    
    passwordSecureButton.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(15)
      $0.trailing.equalToSuperview().inset(8)
    }
    
    stackView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(30)
      $0.height.equalTo(textViewHeight*3 + 36)
    }
    
    stackView.arrangedSubviews.forEach {
      $0.snp.makeConstraints {
        $0.height.equalTo(48)
      }
    }
    
    passwordResetButton.snp.makeConstraints {
      $0.top.equalTo(stackView.snp.bottom).offset(10)
      $0.leading.equalTo(view.snp.leading).offset(30)
      $0.trailing.equalTo(view.snp.trailing).offset(-30)
      $0.height.equalTo(textViewHeight)
    }

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





