//
//  ProfileSelectVC.swift
//  Fastflix
//
//  Created by HongWeonpyo on 24/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class ProfileSelectVC: UIViewController {

  let subUserSingle = SubUserSingleton.shared
  
  // 네이게이션뷰
  lazy var navigationView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.addSubview(profileManageLabel)
    view.addSubview(logoView)
    view.addSubview(changeButton)
    view.addSubview(finishButton)
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
  
  // 프로필관리 레이블(edit할때 나타나는 label)
  let profileManageLabel: UILabel = {
    let label = UILabel()
    label.text = "프로필 관리"
    label.textAlignment = .center
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 17)
    label.isHidden = true
    return label
  }()
  
  // 변경 버튼
  lazy var changeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("변경", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
    return button
  }()
  
  // 완료 버튼
  lazy var finishButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("완료", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(finishButtonTapped(_:)), for: .touchUpInside)
    button.isHidden = true
    return button
  }()
  
  // 안내문구
  let introlabel: UILabel = {
    let label = UILabel()
    label.text = "Fastflix를 시청할 프로필을 선택하세요."
    label.font = UIFont.systemFont(ofSize: 20, weight: .light)
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  var profileImageView1 = UserView()
  var profileImageView2 = UserView()
  var profileImageView3 = UserView()
  var profileImageView4 = UserView()
  var profileImageView5 = UserView()
  var addProfileView = AddProfileView()
  
  var numberOfUsers: Int?
  var subUserList: [SubUser]? {
    didSet {
      numberOfUsers = subUserList?.count
    }
  }
  
  var isFromSeeMoreView: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    navigationBarSetting()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    subUserList = subUserSingle.subUserList
    numberOfUsers = subUserSingle.subUserList?.count
    
    addSubViews()
    setFuntions()
    
    // SeeMore뷰에서 직접 넘어왔다면 변경버튼까지 바로 누른 상태로 실행하기 위함(변경버튼 -> 유저 isEditing상태가 됨)
    if isFromSeeMoreView {
      changeButtonTapped()
    }
    
    print("싱글톤의 유저리스트 viewDidAppear:", subUserSingle.subUserList)
    print("서브유저리스트 viewDidAppear:", subUserList)
    print("numberOfUsers viewDidAppear:", numberOfUsers)
    
    setupSNP()
    setUserViews()
    setupProfileLayout()
    self.view.layoutIfNeeded()
    self.view.setNeedsLayout()
  
  }
  
//  override func viewWillLayoutSubviews() {
//    super.viewWillLayoutSubviews()
//    self.view.translatesAutoresizingMaskIntoConstraints = false
//  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
//    view.setTranslatesAutoresizingMaskIntoConstraints(true)
  }
  

  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    subUserList = subUserSingle.subUserList
//    numberOfUsers = subUserSingle.subUserList?.count
//
//    addSubViews()
//    setFuntions()
//
//    // SeeMore뷰에서 직접 넘어왔다면 변경버튼까지 바로 누른 상태로 실행하기 위함(변경버튼 -> 유저 isEditing상태가 됨)
//    if isFromSeeMoreView {
//      changeButtonTapped()
//    }
//
//    print("싱글톤의 유저리스트 viewDidAppear:", subUserSingle.subUserList)
//    print("서브유저리스트 viewDidAppear:", subUserList)
//    print("numberOfUsers viewDidAppear:", numberOfUsers)
//
//    setupSNP()
//    setUserViews()
//    setupProfileLayout()
//    self.view.layoutIfNeeded()
  }
  
  private func configure() {
    view.backgroundColor = .black
  }
  
  private func addSubViews() {
    [navigationView, introlabel, profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5, addProfileView].forEach { view.addSubview($0) }
  }
  
  func setupSNP() {
    
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
    profileManageLabel.snp.makeConstraints {
      $0.bottom.equalTo(navigationView.snp.bottom).offset(8)
      $0.centerX.equalTo(navigationView.snp.centerX)
      $0.width.equalToSuperview().multipliedBy(0.25)
      $0.height.equalTo(logoView.snp.width).multipliedBy(0.70)
    }
    changeButton.snp.makeConstraints {
      $0.centerY.equalTo(logoView.snp.centerY)
      $0.trailing.equalTo(view.snp.trailing).offset(-15)
    }
    finishButton.snp.makeConstraints {
      $0.centerY.equalTo(logoView.snp.centerY)
      $0.leading.equalTo(view.snp.leading).offset(15)
    }
    introlabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(navigationView.snp.bottom).offset(35)
    }
    profileImageView1.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
      $0.centerX.equalToSuperview().offset(-70)
      $0.top.equalTo(introlabel.snp.bottom).offset(UIScreen.main.bounds.height * 0.03)
    }
    profileImageView2.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
      $0.centerX.equalToSuperview().offset(70)
      $0.top.equalTo(introlabel.snp.bottom).offset(UIScreen.main.bounds.height * 0.03)
    }
    profileImageView3.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
      $0.centerX.equalToSuperview().offset(-70)
      $0.top.equalTo(profileImageView1.snp.bottom).offset(UIScreen.main.bounds.height * 0.03)
    }
    profileImageView4.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
      $0.centerX.equalToSuperview().offset(70)
      $0.top.equalTo(profileImageView1.snp.bottom).offset(UIScreen.main.bounds.height * 0.03)
    }
    profileImageView5.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(profileImageView3.snp.bottom).offset(UIScreen.main.bounds.height * 0.03)
    }
  }
  
  func setupProfileLayout() {
    
    switch numberOfUsers {
    case 1:
      [profileImageView2, profileImageView3, profileImageView4, profileImageView5].forEach { $0.isHidden = true }
      [profileImageView1].forEach { $0.isHidden = false }
      // 연필 움직이는 효과 구현
      UIView.animate(withDuration: 0.1) {
        self.addProfileView.snp.makeConstraints {
          $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
          $0.centerX.equalToSuperview().offset(70)
          $0.top.equalTo(self.introlabel.snp.bottom).offset(UIScreen.main.bounds.height * 0.03)
//          $0.top.equalTo(self.introlabel.snp.bottom).offset(UIScreen.main.bounds.width * 0.32 + 40)
        }
      }
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5, addProfileView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      
    case 2:
      [profileImageView3, profileImageView4, profileImageView5].forEach { $0.isHidden = true }
      [profileImageView1, profileImageView2].forEach { $0.isHidden = false }
      // 연필 움직이는 효과 구현
      UIView.animate(withDuration: 0.1) {
        self.addProfileView.snp.makeConstraints {
          $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
          $0.centerX.equalToSuperview()
          $0.top.equalTo(self.introlabel.snp.bottom).offset(UIScreen.main.bounds.width * 0.32 + 78)
//          $0.top.equalTo(self.profileImageView1.snp.bottom).offset(UIScreen.main.bounds.height * 0.03)
        }
      }
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5, addProfileView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      
    case 3:
      [profileImageView4, profileImageView5].forEach { $0.isHidden = true }
      [profileImageView1, profileImageView2, profileImageView3].forEach { $0.isHidden = false }
      // 연필 움직이는 효과 구현
      UIView.animate(withDuration: 0.1) {
        self.addProfileView.snp.makeConstraints {
          $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
          $0.centerX.equalToSuperview().offset(70)
//          $0.top.equalTo(self.profileImageView1.snp.bottom).offset(UIScreen.main.bounds.height * 0.03)
          $0.top.equalTo(self.introlabel.snp.bottom).offset(UIScreen.main.bounds.width * 0.32 + 78)
        }
      }
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5, addProfileView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      
    case 4:
      profileImageView5.isHidden = true
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4].forEach { $0.isHidden = false }
      // 연필 움직이는 효과 구현
      UIView.animate(withDuration: 0.1) {
        self.addProfileView.snp.makeConstraints {
          $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
          $0.centerX.equalToSuperview()
//          $0.top.equalTo(self.profileImageView3.snp.bottom).offset(UIScreen.main.bounds.height * 0.03)
          $0.top.equalTo(self.introlabel.snp.bottom).offset((UIScreen.main.bounds.width * 0.32 + 78)*2)
        }
      }
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5, addProfileView].forEach {
        $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      
    case 5:
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5].forEach { $0.isHidden = false }
      // 연필 움직이는 효과 구현
      UIView.animate(withDuration: 0.1) {
        self.addProfileView.snp.makeConstraints {
          $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
          $0.centerX.equalToSuperview()
          $0.top.equalTo(self.profileImageView3.snp.bottom).offset(UIScreen.main.bounds.height * 0.03)
        }
      }
      addProfileView.isHidden = true
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5, addProfileView].forEach {
        $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      
    default:
      addProfileView.isHidden = true
    }
  }
  
  func setUserViews() {
  
    switch numberOfUsers {
    case 5:
      profileImageView5.profileUserName = subUserList?[4].name
      profileImageView5.tag = (subUserList?[4].id)!
      profileImageView5.configureImage(imageURLString: subUserList?[4].profileInfo.profileImagePath)
      fallthrough
    case 4:
      profileImageView4.profileUserName = subUserList?[3].name
      profileImageView4.tag = (subUserList?[3].id)!
      profileImageView4.configureImage(imageURLString: subUserList?[3].profileInfo.profileImagePath)
      fallthrough
    case 3:
      profileImageView3.profileUserName = subUserList?[2].name
      profileImageView3.tag = (subUserList?[2].id)!
      profileImageView3.configureImage(imageURLString: subUserList?[2].profileInfo.profileImagePath)
      fallthrough
    case 2:
      profileImageView2.profileUserName = subUserList?[1].name
      profileImageView2.tag = (subUserList?[1].id)!
      profileImageView2.configureImage(imageURLString: subUserList?[1].profileInfo.profileImagePath)
      fallthrough
    case 1:
      profileImageView1.profileUserName = subUserList?[0].name
      profileImageView1.tag = (subUserList?[0].id)!
      profileImageView1.configureImage(imageURLString: subUserList?[0].profileInfo.profileImagePath)
    default:
      return
    }
  }
  
  
  private func navigationBarSetting() {
    let navCon = navigationController!
    navCon.isNavigationBarHidden = true
  }
  
  // MARK: - "변경"버튼 누르면 UserView의 모든 isEditing속성을 바꿔서 편집가능한 상태로 만듦
  // 상단의 레이블 상태 변경
  @objc func changeButtonTapped() {
    // 상단 레이블 변경
    [profileManageLabel, finishButton].forEach { $0.isHidden = false }
    [changeButton, logoView, introlabel ].forEach { $0.isHidden = true }
    // UserView의 모든 isEditing속성을 바꾸기
    [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5].forEach { $0.isEditing = true }
    // 연필 변경되는 효과 주기 위해서
    UIView.animate(withDuration: 0.01, animations: {
      [self.profileImageView1.editImageView, self.profileImageView2.editImageView, self.profileImageView3.editImageView, self.profileImageView4.editImageView, self.profileImageView5.editImageView].forEach { $0.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2) }
    }, completion: { (finish) in
      UIView.animate(withDuration: 0.4, animations: {
        [self.profileImageView1.editImageView, self.profileImageView2.editImageView, self.profileImageView3.editImageView, self.profileImageView4.editImageView, self.profileImageView5.editImageView].forEach { $0.transform = CGAffineTransform.identity }
      })
    })
  }
  
  // MARK: - "완료"버튼 누를 때 메서드
  @objc private func finishButtonTapped(_ sender: UIButton) {
    // SeeMore뷰에서 왔으면 종료버튼 누를때 바로 dismiss
    if isFromSeeMoreView {
      dismiss(animated: true)
    // 아닌 경우, 상단 레이블 바꾸고, 모든 UserView의 isEditing 속성 다시 바꿔주기 (편집가능하지 않은 상태로)
    }else {
      [profileManageLabel, finishButton].forEach { $0.isHidden = true }
      [changeButton, logoView, introlabel ].forEach { $0.isHidden = false }
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5].forEach { $0.isEditing = false }
    }
  }
  
  // 델리게이트 설정
  private func setFuntions() {
    [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5].forEach { $0.delegate = self }
    addProfileView.delegate = self
  }
  
}

// MARK: - UserView에 관한 델리게이트 구현
extension ProfileSelectVC: UserViewDelegate {
  
  // 1) 편집이 가능하지 않은 상태(!isEditing) 로그인 하기 위해서 특정 유저를 선택
  func didSelectUser(tag: Int) {
    print("유저 선택하기 눌렸당, 서브유저아이디 Tag:", tag)
    
    APICenter.shared.saveSubUserID(id: tag)
    DispatchQueue.main.async {
      AppDelegate.instance.checkLoginState()
    }
    
    //    let tabBar = MainTabBarController()
    //    present(tabBar, animated: false)
  }
  
  // 2) 편집이 가능한 상태(isEditing)에서 프로필 변경을 위한 특정 유저 선택
  func profileChangeTapped(tag: Int, userName: String, userImage: UIImage) {
    print("프로필 변경을 위한 - 특정 유저 선택 하기 눌렀당")
    let profileChangeVC = ProfileChangeVC()
    profileChangeVC.subUserIDtag = tag
    profileChangeVC.userName = userName
    profileChangeVC.userImage = userImage
    guard let user = subUserList?.filter({ $0.id == tag }) else { return }
    profileChangeVC.kidChecking = user[0].kid
    profileChangeVC.isUserCreating = false
    let navi = UINavigationController(rootViewController: profileChangeVC)
    navigationController?.present(navi, animated: true)
  }

}

// MARK: - 프로필 추가(AddProfileView)에 관한 델리게이트 구현
extension ProfileSelectVC: AddProfileViewDelegate {
  func addProfileButtonTapped() {
    print("프로필추가 눌렀음====================동작바람")
    let profileChangeVC = ProfileChangeVC()
    profileChangeVC.userName = ""
    profileChangeVC.isUserCreating = true
    let navi = UINavigationController(rootViewController: profileChangeVC)
    navigationController?.present(navi, animated: true)
  
  }
  
}
