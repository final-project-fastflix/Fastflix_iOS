//
//  ProfileChangeVC.swift
//  Fastflix
//
//  Created by HongWeonpyo on 25/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class ProfileChangeVC: UIViewController {
  
  let userIconSelectVC = UserIconSelectVC()

  let subUserSingle = SubUserSingleton.shared
  
  // 네이게이션뷰
  lazy var navigationView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.addSubview(profileChangeLabel)
    view.addSubview(saveButton)
    view.addSubview(cancelButton)
    return view
  }()
  
  // 프로필관리 레이블(edit할때 나타나는 label)
  let profileChangeLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 17)
    return label
  }()
  
  // 저장 버튼
  lazy var saveButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("저장", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
    return button
  }()
  
  // 취소 버튼
  lazy var cancelButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("취소", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
    return button
  }()
  
  var userView = UserView()
  
  // MARK: - 유저에 관한 정보 저장 속성
  var subUserIDtag: Int?
  var userName: String?
  var userImage: UIImage?
  var profileImagePath: String?
  
  
  var kidChecking: Bool = false {
    didSet {
      kidsSwitchButton.setOn(kidChecking, animated: true)
    }
  }
  
  // MARK: - 유저 생성중인지 여부 확인
  var isUserCreating: Bool = false
  
  let textSurroundingView: UIView = {
    let view = UIView()
    view.layer.borderWidth = 1
    view.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    return view
  }()
  
  var subUserNameTextField: UITextField = {
    let tf = UITextField()
    tf.backgroundColor = .black
    tf.textColor = .white
    tf.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    return tf
  }()
  
  let kidsLabel: UILabel = {
    let label = UILabel()
    label.text = "키즈용"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 17)
    return label
  }()
  
  let kidsSwitchButton: UISwitch = {
    let switchButton = UISwitch()
    switchButton.onTintColor = #colorLiteral(red: 0, green: 0.4823529412, blue: 0.9960784314, alpha: 1)
    return switchButton
  }()
  
  lazy var kidsStackView: UIStackView = {
    var sv = UIStackView(arrangedSubviews: [kidsLabel, kidsSwitchButton])
    sv.spacing = 15
    sv.axis = .horizontal
    sv.distribution = .fill
    sv.isHidden = true
    return sv
  }()
  
  let deleteButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("삭제", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
    return button
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    configure()
    addSubViews()
    navigationBarSetting()
    setFuntions()
    
    setupSNP()
    kidsStackView.isHidden = false
    subUserNameTextField.becomeFirstResponder()
    checkDeleteButtonStatus()
  }

  private func configure() {
//    view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    view.backgroundColor = .black
    userView.profileUserName = "변경"
    subUserNameTextField.text = userName ?? ""
    userView.userImageView.image = userImage ?? UIImage(named: "profile1")
    profileChangeLabel.text = isUserCreating ? "프로필 만들기" : "프로필 변경"
    subUserNameTextField.delegate = self
  }
  
  private func addSubViews() {
    [navigationView, userView, textSurroundingView, subUserNameTextField, kidsStackView, deleteButton].forEach { view.addSubview($0) }
  }
  
  private func setupSNP() {
    
    navigationView.snp.makeConstraints {
      $0.top.equalTo(view.snp.top)
      $0.leading.equalTo(view.snp.leading)
      $0.trailing.equalTo(view.snp.trailing)
      $0.height.equalTo(UIScreen.main.bounds.height * 0.11)
    }
    
    profileChangeLabel.snp.makeConstraints {
      $0.bottom.equalTo(navigationView.snp.bottom).offset(8)
      $0.centerX.equalTo(navigationView.snp.centerX)
      $0.width.equalToSuperview().multipliedBy(0.25)
      $0.height.equalTo(profileChangeLabel.snp.width).multipliedBy(0.70)
    }
    
    saveButton.snp.makeConstraints {
      $0.centerY.equalTo(profileChangeLabel.snp.centerY)
      $0.trailing.equalTo(view.snp.trailing).offset(-15)
    }
    
    cancelButton.snp.makeConstraints {
      $0.centerY.equalTo(profileChangeLabel.snp.centerY)
      $0.leading.equalTo(view.snp.leading).offset(15)
    }
    
    userView.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width * 0.28)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(navigationView.snp.bottom).offset(40)
    }
    
    textSurroundingView.snp.makeConstraints {
      $0.top.equalTo(userView.snp.bottom).offset(30)
      $0.leading.trailing.equalToSuperview().inset(45)
      $0.height.equalTo(45)
    }
    
    subUserNameTextField.snp.makeConstraints {
      $0.top.bottom.equalTo(textSurroundingView).inset(5)
      $0.leading.trailing.equalTo(textSurroundingView).inset(10)
    }
    
    kidsStackView.snp.makeConstraints {
      $0.top.equalTo(textSurroundingView.snp.bottom).offset(30)
      $0.centerX.equalTo(textSurroundingView.snp.centerX)
    }
    
    deleteButton.snp.makeConstraints {
      $0.top.equalTo(kidsStackView.snp.bottom).offset(30)
      $0.centerX.equalTo(textSurroundingView.snp.centerX)
    }
    
  }
  
//  private func CheckKid() {
//      kidsSwitchButton.setOn(kidChecking, animated: false)
//  }
  
  private func navigationBarSetting() {
    let navCon = navigationController!
    navCon.navigationBar.barTintColor = .black
    navCon.isNavigationBarHidden = true
  }
  
  @objc private func saveButtonTapped(_ sender: UIButton) {
    print("새로바뀐 유저정보 저장관련 메서드 넣어야함")
    saveChangedUserInfo() {
      self.dismiss(animated: true)
    }
  }
  
  private func saveChangedUserInfo(completion: @escaping () -> ()) {
    guard let name = subUserNameTextField.text else { return }
    let kid = kidsSwitchButton.isOn
    
    if isUserCreating {
      print("유저 새로 만들고 있는데???")
      APICenter.shared.createSubUser(name: name, kid: kid) {
        switch $0 {
        case .success(let subUsers):
          print("User Creating Success!!!")
          print("value: ", subUsers)
          self.subUserSingle.subUserList = subUsers
          completion()
        case .failure(let err):
          print("fail to login, reason: ", err)
        }
      }
    }else {
      print("유저 변경하고 있는데???")
      print("키즈여부:", kid)
      guard let subUserID = subUserIDtag else { return print("서브유저 아이디가 없다고?? 말이됨?") }
      
      APICenter.shared.changeProfileInfo(id: subUserID, name: name, kid: kid, imgPath: profileImagePath) { (result) in
        switch result {
        case .success(let value):
          print("result1: ", value)
          if value == 0 {
            print("변경 저장 실험해보기 - 그대로")
          }else {
            // 변경 성공했으니 유저리스트 다시 받아와서 싱글톤에 저장
            print("변경 저장 실험해보기 - 유저바꾸기")
            self.regetSubUserList() {
              self.dismiss(animated: true)
            }
          }
        case .failure(let err):
          print("result1: ", err)
        }
//        self.dismiss(animated: true)
      }
    }
  }
  
  // 유저 변경했으니 전체적인 서브유저 리스트를 다시 받아오는 메서드
  func regetSubUserList(completion: @escaping () -> ()) {
    APICenter.shared.getSubUserList() {
      switch $0 {
      case .success(let subUsers):
        print("Get SubuserList Success!!!")
        self.subUserSingle.subUserList = subUsers
        completion()
      case .failure(let err):
        print("fail to login, reason: ", err)
      }
    }
  }

  @objc private func cancelButtonTapped(_ sender: UIButton) {
    print("취소")
    dismiss(animated: true)
  }
  
  @objc private func deleteButtonTapped(_ sender: UIButton) {
    print("삭제 누름")
    deleteSubUser {
      self.dismissingView()
    }
  }
  
  private func deleteSubUser(completion: @escaping () -> ()) {
    alert(title: "프로필 삭제", message: "이 프로필을 삭제하시겠어요?") {
      //프로필 삭제시 - 클로저로 기능 구현 코드 넣어야 함
      APICenter.shared.deleteProfileInfo(id: self.subUserIDtag!) { (result) in
        switch result {
        case .success(let value):
          print("지우기 결과 성공 result: ", value)
          self.regetSubUserList() {
            completion()
          }
        case .failure(let err):
          print("지우기 결과 실패 result: ", err)
        }
      }
    }
  }
  
  
  func dismissingView() {
    guard let navi = presentingViewController as? UINavigationController else { return }
    guard let profileSelectVC = navi.viewControllers.last as? ProfileSelectVC else { return }
    
    profileSelectVC.viewWillAppear(true)
    
    dismiss(animated: true)
    
  }
  
  
  // 텍스트필드에 아무것도 없으면 저장 버튼 비활성화
  @objc private func editingChanged(_ textField: UITextField) {
    if textField.text?.count == 1 {
      if textField.text?.first == " " {
        textField.text = ""
        return
      }
    }
    guard
      let username = subUserNameTextField.text, !username.isEmpty
      else {
        saveButton.setTitleColor(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
        saveButton.isEnabled = false
        return
    }
    saveButton.setTitleColor(.white, for: .normal)
    saveButton.isEnabled = true
  }
  
  // MARK: - 삭제버튼이 비활성화의 경우에 대한 상황체크
  private func checkDeleteButtonStatus() {
    // 메인(첫번째 유저이거나), 지금현재 선택된 유저이거나, 유저를 만들고 있는 경우엔 삭제버튼 비활성화
    if subUserSingle.subUserList?[0].id == subUserIDtag || APICenter.shared.getSubUserID() == subUserIDtag || isUserCreating {
      deleteButton.isHidden = true
    }
  }
  
}

// MARK: - 변경(UserView)을 선택했을 때 유저아이콘들 선택하는(UserIconSelectVC)뷰컨트롤러로 넘어가기 위한 델리게이트 구현
extension ProfileChangeVC: UserViewDelegate {
  
  private func setFuntions() {
    userView.delegate = self
  }
  
  // 유저뷰(UserView)를 눌렀을때 이미지변경을 위한 이미지를 다 받은 다음 UserIconSelectVC로 넘어가기
  func toUserIconSelectVC() {
    print("유저아이콘 선택화면으로 이동하는 메서드 구현")
    
    APICenter.shared.changeProfileImage { (result) in
      switch result {
      case .success(let profileImage):
        print("이미지변경 버튼 성공 Images 받기: ", profileImage)
        self.userIconSelectVC.profileImages = profileImage
        self.userIconSelectVC.categories = profileImage.keys.sorted()
        DispatchQueue.main.async {
          self.navigationController?.pushViewController(self.userIconSelectVC, animated: true)
        }
      case .failure(let err):
        print("넘어가기 실패 result: ", err)
      }
    }
  }
  
  func profileChangeTapped(tag: Int, userName: String, userImage: UIImage, imageURL: String) {
    
    print("유저변경 사항 저장 구현???")
    
    
  }
  
  func didSelectUser(tag: Int) {
    //델리게이트로 구현되어있지만, 이 VC에서는 이 메서드 실행될 일 없음(-->옵셔널로)
  }
}

// MARK: - 버튼 비활성화를 위한 텍스트필드 델리게이트 구현
extension ProfileChangeVC: UITextFieldDelegate {
  
  //프로필 추가시에는 시작부터 텍스트 없기 때문에 버튼 비활성화 시키키 위해 텍스트필드 메서드 이용
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField.text?.count == 1 {
      if textField.text?.first == " " {
        textField.text = ""
        return
      }
    }
    guard
      let username = subUserNameTextField.text, !username.isEmpty
      else {
        saveButton.setTitleColor(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
        saveButton.isEnabled = false
        return
    }
    saveButton.setTitleColor(.white, for: .normal)
    saveButton.isEnabled = true
  }
}
