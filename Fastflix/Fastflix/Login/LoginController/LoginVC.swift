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
    
    viewsAddTargetSetting()
    navigationBarSetting()
  }
  
  // MARK: - view에서 버튼에 addTarget 필요한 부분 셋팅
  private func viewsAddTargetSetting() {
    
    rootView.customerCenterButton.addTarget(self, action: #selector(customerCenterTapped(_:)), for: .touchUpInside)
    rootView.backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    rootView.bigBackButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    rootView.loginButton.addTarget(self, action: #selector(didTapLoginBtn(_:)), for: .touchUpInside)
  }
  
  
  // 네비게이션바 세팅
  private func navigationBarSetting() {
    let navCon = navigationController!
    navCon.isNavigationBarHidden = true
  }
  
  
  // MARK: - 로그인버튼 눌렀을 때의 동작
  @objc private func didTapLoginBtn(_ sender: UIButton) {
    guard let id = rootView.emailTextField.text, let pw = rootView.passwordTextField.text else { return }
    
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
  
  // MARK: - 고객센터버튼 눌렀을 때
  @objc private func customerCenterTapped(_ sender: UIButton) {
    let customerCenterVC = CustomerCenterVC()
    present(customerCenterVC, animated: true)
  }
  
  // MARK: - 뒤로가기 버튼을 눌렀을 때
  @objc private func backButtonTapped(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
}






