//
//  ProfileSelectView.swift
//  Fastflix
//
//  Created by HongWeonpyo on 16/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

class ProfileSelectView: UIView {
  
  private let subUserSingle = SubUserSingleton.shared
  
  // 네이게이션뷰
  private lazy var navigationView: UIView = {
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
  
  // MARK: - 프로필관리 레이블(edit할때만 나타나는 label)
  let profileManageLabel: UILabel = {
    let label = UILabel()
    label.text = "프로필 관리"
    label.textAlignment = .center
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 17)
    label.isHidden = true
    return label
  }()
  
  // MARK: - 변경 버튼  ====> 편집모드로
  lazy var changeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("변경", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
//    button.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
    return button
  }()
  
  // MARK: - 변경 완료 버튼
  lazy var finishButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("완료", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
//    button.addTarget(self, action: #selector(finishButtonTapped(_:)), for: .touchUpInside)
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
  
  // MARK: - 서브유저 관련 5개의 뷰를 일단은 다 올려놓음 - 존재유뮤에 따라 isHidden으로 숨김
  // 커스텀해서 만든 UserView
  var profileImageView1 = UserView()
  var profileImageView2 = UserView()
  var profileImageView3 = UserView()
  var profileImageView4 = UserView()
  var profileImageView5 = UserView()
  
  // 프로필추가 버튼(커스텀뷰)
  var addProfileView = AddProfileView()
  
  // MARK: - 서브유저의 숫자
  var numberOfUsers: Int?
  
  var subUserList: [SubUser]? {
    didSet {
      numberOfUsers = subUserList?.count
    }
  }
  
  // MARK: - 레이아웃 설정을 위한 높이 관련 속성
  private let firstYLine = UIScreen.main.bounds.height * 0.32
  private lazy var secondYLine = firstYLine + 180
  private lazy var thirdYLine = secondYLine + 180
  
  // MARK: - SeeMore뷰에서 왔는지(또는 로그인하면서 뷰를 띄웠는지) 여부
  // SeeMore뷰에서 접근하면 바로 "편집(editing)모드"로 가기 위함
//  var isFromSeeMoreView: Bool = false
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    //    subUserList = subUserSingle.subUserList
    //    numberOfUsers = subUserSingle.subUserList?.count
    
    
    configure()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    // 뷰가 나타날때마다 서브유저 및 서브유저 숫자 확인
    subUserList = subUserSingle.subUserList
    numberOfUsers = subUserSingle.subUserList?.count
    
//    setDelegates()
    addSubViews()
    
    // SeeMore뷰에서 직접 넘어왔다면 "변경"버튼까지 바로 누른 상태로 가기(변경버튼 -> 유저 isEditing상태가 됨)
//    if isFromSeeMoreView {
//      let vc = self.parentViewController as? ProfileSelectVC
//      vc?.changeButtonTapped()
//    }
    
    setupSNP()
    setUserViews()
    setupProfileLayout()
    
  }
  
  private func configure() {
    backgroundColor = .black
  }
  
  // 델리게이트 설정
//  private func setDelegates() {
//    [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5].forEach { $0.delegate = self }
//    addProfileView.delegate = self
//  }
  
  private func addSubViews() {
    // ProfileChangeVC에서 유저 추가 또는 삭제가 되었을때 레이아웃 변경을 위해서
    // 일단은 객체 다 슈퍼뷰에서 삭제하기
    [navigationView, introlabel, profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5, addProfileView].forEach { $0.removeFromSuperview() }
    
    [navigationView, introlabel, profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5, addProfileView].forEach { addSubview($0) }
  }
  
  private func setupSNP() {
    
    navigationView.snp.makeConstraints {
      $0.top.equalTo(self.snp.top)
      $0.leading.equalTo(self.snp.leading)
      $0.trailing.equalTo(self.snp.trailing)
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
      $0.trailing.equalTo(self.snp.trailing).offset(-15)
    }
    finishButton.snp.makeConstraints {
      $0.centerY.equalTo(logoView.snp.centerY)
      $0.leading.equalTo(self.snp.leading).offset(15)
    }
    introlabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalTo(self.snp.top).offset(UIScreen.main.bounds.height * 0.15)
    }
    profileImageView1.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
      $0.centerX.equalToSuperview().offset(-70)
      $0.centerY.equalTo(self.snp.top).offset(self.firstYLine)
    }
    profileImageView2.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
      $0.centerX.equalToSuperview().offset(70)
      $0.centerY.equalTo(self.snp.top).offset(self.firstYLine)
    }
    profileImageView3.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
      $0.centerX.equalToSuperview().offset(-70)
      $0.centerY.equalTo(self.snp.top).offset(self.secondYLine)
    }
    profileImageView4.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
      $0.centerX.equalToSuperview().offset(70)
      $0.centerY.equalTo(self.snp.top).offset(self.secondYLine)
    }
    profileImageView5.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
      $0.centerX.equalToSuperview()
      $0.centerY.equalTo(self.snp.top).offset(self.thirdYLine)
    }
  }
  
  // MARK: - 서브유저의 숫자에 따라 레이아웃 잡기
  func setupProfileLayout() {
    
    switch numberOfUsers {
    case 1:
      [profileImageView2, profileImageView3, profileImageView4, profileImageView5].forEach { $0.isHidden = true }
      [profileImageView1, addProfileView].forEach { $0.isHidden = false }
      // 프로필추가 버튼 위치 잡기
      UIView.animate(withDuration: 0.1) {
        self.addProfileView.snp.makeConstraints {
          $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
          $0.centerX.equalToSuperview().offset(70)
          $0.centerY.equalTo(self.snp.top).offset(self.firstYLine)
        }
      }
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5, addProfileView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      
    case 2:
      [profileImageView3, profileImageView4, profileImageView5].forEach { $0.isHidden = true }
      [profileImageView1, profileImageView2, addProfileView].forEach { $0.isHidden = false }
      // 프로필추가 버튼 위치 잡기
      UIView.animate(withDuration: 0.1) {
        self.addProfileView.snp.makeConstraints {
          $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
          $0.centerX.equalToSuperview()
          $0.centerY.equalTo(self.snp.top).offset(self.secondYLine)
        }
      }
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5, addProfileView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      
    case 3:
      [profileImageView4, profileImageView5].forEach { $0.isHidden = true }
      [profileImageView1, profileImageView2, profileImageView3, addProfileView].forEach { $0.isHidden = false }
      // 프로필추가 버튼 위치 잡기
      UIView.animate(withDuration: 0.1) {
        self.addProfileView.snp.makeConstraints {
          $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
          $0.centerX.equalToSuperview().offset(70)
          $0.centerY.equalTo(self.snp.top).offset(self.secondYLine)
        }
      }
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5, addProfileView].forEach { $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      
    case 4:
      profileImageView5.isHidden = true
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, addProfileView].forEach { $0.isHidden = false }
      // 프로필추가 버튼 위치 잡기
      UIView.animate(withDuration: 0.1) {
        self.addProfileView.snp.makeConstraints {
          $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
          $0.centerX.equalToSuperview()
          $0.centerY.equalTo(self.snp.top).offset(self.thirdYLine)
        }
      }
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5, addProfileView].forEach {
        $0.setNeedsLayout()
        $0.layoutIfNeeded()
      }
      
    case 5:
      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5].forEach { $0.isHidden = false }
      // 프로필추가 버튼 위치 잡기
      UIView.animate(withDuration: 0.1) {
        self.addProfileView.snp.makeConstraints {
          $0.width.equalTo(UIScreen.main.bounds.width * 0.32)
          $0.centerX.equalToSuperview()
          $0.centerY.equalTo(self.snp.top).offset(self.thirdYLine)
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
  
  // MARK: - 프로파일 뷰에 표시할 내용을 유저 숫자에 따라 표현하기
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
  
  // MARK: - "변경"버튼 누르면 UserView의 모든 isEditing속성을 바꿔서 편집가능한 상태로 만듦
  // 상단의 레이블 상태 변경
//  @objc func changeButtonTapped() {
//    // 상단 레이블 변경
//    [profileManageLabel, finishButton].forEach { $0.isHidden = false }
//    [changeButton, logoView, introlabel ].forEach { $0.isHidden = true }
//    // UserView의 모든 isEditing속성을 바꾸기
//    [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5].forEach { $0.isEditing = true }
//    // 연필 변경되는 효과 주기 위해서
//    UIView.animate(withDuration: 0.01, animations: {
//      [self.profileImageView1.editImageView, self.profileImageView2.editImageView, self.profileImageView3.editImageView, self.profileImageView4.editImageView, self.profileImageView5.editImageView].forEach { $0.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2) }
//    }, completion: { (finish) in
//      UIView.animate(withDuration: 0.4, animations: {
//        [self.profileImageView1.editImageView, self.profileImageView2.editImageView, self.profileImageView3.editImageView, self.profileImageView4.editImageView, self.profileImageView5.editImageView].forEach { $0.transform = CGAffineTransform.identity }
//      })
//    })
//  }
  
  // MARK: - "완료"버튼 누를 때 메서드
//  @objc private func finishButtonTapped(_ sender: UIButton) {
//    // SeeMore뷰에서 왔으면 종료버튼 누를때 바로 dismiss
//    if isFromSeeMoreView {
//      dismiss(animated: true)
//      // 아닌 경우, 상단 레이블 바꾸고, 모든 UserView의 isEditing 속성 다시 바꿔주기 (편집가능하지 않은 상태로)
//    }else {
//      [profileManageLabel, finishButton].forEach { $0.isHidden = true }
//      [changeButton, logoView, introlabel ].forEach { $0.isHidden = false }
//      [profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5].forEach { $0.isEditing = false }
//    }
//  }
}

//extension UIResponder {
//  public var parentViewController: UIViewController? {
//    return next as? UIViewController ?? next?.parentViewController
//  }
//}


