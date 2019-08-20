//
//  ProfileSelectVC.swift
//  Fastflix
//
//  Created by HongWeonpyo on 24/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

final class ProfileSelectVC: UIViewController {

  private let subUserSingle = SubUserSingleton.shared
  
  // 프로필 바꾸고나서의 객체에 접근하기 위해서 private으로 선언하지 않음
  let profileChangeVC = ProfileChangeVC()
  private let rootView = ProfileSelectView()
  
  
  // 스태터스 바
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func loadView() {
    view = rootView
  
  }
  
  
  // MARK: - 서브유저의 숫자
  var numberOfUsers: Int?
  
  var subUserList: [SubUser]? {
    didSet {
      numberOfUsers = subUserList?.count
    }
  }

  
  // MARK: - SeeMore뷰에서 왔는지(또는 로그인하면서 뷰를 띄웠는지) 여부
  // SeeMore뷰에서 접근하면 바로 "편집(editing)모드"로 가기 위함
  var isFromSeeMoreView: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    subUserList = subUserSingle.subUserList
//    numberOfUsers = subUserSingle.subUserList?.count
    
    
    setupAddTarget()
    navigationBarSetting()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // 뷰가 나타날때마다 서브유저 및 서브유저 숫자 확인
    subUserList = subUserSingle.subUserList
    numberOfUsers = subUserSingle.subUserList?.count
    
    setDelegates()
//    addSubViews()
  
    // SeeMore뷰에서 직접 넘어왔다면 "변경"버튼까지 바로 누른 상태로 가기(변경버튼 -> 유저 isEditing상태가 됨)
    if isFromSeeMoreView {
      changeButtonTapped()
    }
    
//    setUserViews()
//    setupProfileLayout()
    
  }
  
  private func navigationBarSetting() {
    let navCon = navigationController!
    navCon.isNavigationBarHidden = true
  }
  
  
  func setupAddTarget() {
    rootView.changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
    rootView.finishButton.addTarget(self, action: #selector(finishButtonTapped(_:)), for: .touchUpInside)
  }
  
  // 델리게이트 설정
  private func setDelegates() {
    [rootView.profileImageView1, rootView.profileImageView2, rootView.profileImageView3, rootView.profileImageView4, rootView.profileImageView5].forEach { $0.delegate = self }
    rootView.addProfileView.delegate = self
  }
  

  // MARK: - "변경"버튼 누르면 UserView의 모든 isEditing속성을 바꿔서 편집가능한 상태로 만듦
  // 상단의 레이블 상태 변경
  @objc func changeButtonTapped() {
    // 상단 레이블 변경
    [rootView.profileManageLabel, rootView.finishButton].forEach { $0.isHidden = false }
    [rootView.changeButton, rootView.logoView, rootView.introlabel ].forEach { $0.isHidden = true }
    // UserView의 모든 isEditing속성을 바꾸기
    [rootView.profileImageView1, rootView.profileImageView2, rootView.profileImageView3, rootView.profileImageView4, rootView.profileImageView5].forEach { $0.isEditing = true }
    // 연필 변경되는 효과 주기 위해서
    UIView.animate(withDuration: 0.01, animations: {
      [self.rootView.profileImageView1.editImageView, self.rootView.profileImageView2.editImageView, self.rootView.profileImageView3.editImageView, self.rootView.profileImageView4.editImageView, self.rootView.profileImageView5.editImageView].forEach { $0.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2) }
    }, completion: { (finish) in
      UIView.animate(withDuration: 0.4, animations: {
        [self.rootView.profileImageView1.editImageView, self.rootView.profileImageView2.editImageView, self.rootView.profileImageView3.editImageView, self.rootView.profileImageView4.editImageView, self.rootView.profileImageView5.editImageView].forEach { $0.transform = CGAffineTransform.identity }
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
      [rootView.profileManageLabel, rootView.finishButton].forEach { $0.isHidden = true }
      [rootView.changeButton, rootView.logoView, rootView.introlabel ].forEach { $0.isHidden = false }
      [rootView.profileImageView1, rootView.profileImageView2, rootView.profileImageView3, rootView.profileImageView4, rootView.profileImageView5].forEach { $0.isEditing = false }
    }
  }
}

// MARK: - UserView에 관한 델리게이트 구현
extension ProfileSelectVC: UserViewDelegate {
  
  // 1) 편집이 가능하지 않은 상태(!isEditing) 로그인 하기 위해서 특정 유저를 선택 ====> 홈화면으로
  func didSelectUser(tag: Int) {
    print("유저 선택하기 눌렸당, 서브유저아이디 Tag:", tag)
    APICenter.shared.saveSubUserID(id: tag)
    AppDelegate.instance.reloadRootView()
  }
  
  // 2) 편집이 가능한 상태(isEditing)에서 프로필 변경을 위한 특정 유저 선택
  func profileChangeTapped(tag: Int, userName: String, userImage: UIImage, imageURL: String) {
    print("프로필 변경을 위한 - 특정 유저 선택 하기 눌렀당")
    
    // 유저에 대한 정보는 UserView에서 받아와서 profileChangeVC를 띄움
    profileChangeVC.subUserIDtag = tag
    
    // 받아온 서브유저 태그(아이디)와 일치하는 서브유저 뽑아내서 정보넘김
    guard let user = subUserList?.filter({ $0.id == tag }) else { return }
    
    profileChangeVC.userName = userName
    profileChangeVC.userImage = userImage
    profileChangeVC.profileImagePath = imageURL
    profileChangeVC.kidChecking = user[0].kid
    
    profileChangeVC.isUserCreating = false
    profileChangeVC.userView.isForImageSelecting = true
  
    
    let navi = UINavigationController(rootViewController: profileChangeVC)
    navigationController?.present(navi, animated: true)
//    present(navi, animated: true)
  }
  
  func toUserIconSelectVC() {}

}

// MARK: - 프로필 추가(AddProfileView)에 관한 델리게이트 구현
extension ProfileSelectVC: AddProfileViewDelegate {
  
  func addProfileButtonTapped() {
    
    // 유저 생성중임을 ProfileChangeVC에 알려주기(속성 설정)
    profileChangeVC.isUserCreating = true
    profileChangeVC.userName = ""
    profileChangeVC.userView.userImageView.image = nil
    profileChangeVC.userView.isForImageSelecting = true
    
    let navi = UINavigationController(rootViewController: profileChangeVC)
    navigationController?.present(navi, animated: true)
  }
}
